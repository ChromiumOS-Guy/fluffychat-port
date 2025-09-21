#!/usr/bin/python3
'''
 Copyright (C) 2022  UBPorts

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 3.

 udeb is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''
import os
import sys
import subprocess


#### Functions
def get_lcd_density() -> int:
  # getprop vendor.display.lcd_density
  lcd_density = None
  process = None
  try:
    # Start the QML process, capturing stdout
    process = subprocess.Popen(
        ["getprop", "vendor.display.lcd_density"],
        stdout=subprocess.PIPE,
        text=True,  # Decode output as text
        bufsize=1,  # Line-buffered output
        universal_newlines=True # Ensure consistent newline handling
    )
    lcd_density = int(process.stdout.readline().strip())

  except Exception as e:
    print(f"An error occurred: {e}")
    return 0
  finally:
    if process and process.poll() is None:  # Check if the process is still running
        print("Killing process...")
        process.terminate()  # Send a terminate signal
        try:
          process.wait(timeout=5)  # Wait for the process to terminate
        except subprocess.TimeoutExpired:
          print("Process did not terminate gracefully, killing it.")
          process.kill()  # Force kill if termination fails
  
  return lcd_density

def scalingdevidor(GRID_PX : int = int(os.environ["GRID_UNIT_PX"])) -> int: # getprop vendor.display.lcd_density
  if GRID_PX >= 21: # seems to be what most need if above or at 21 grid px
    return 8
  elif GRID_PX <= 16: # this one i know because my phone (N100) is 16 so if it seems weird don't worry it works.
    return 12
  else: # throw in the dark but lets hope it works
    return 10


#### GLOBAL VARIABLES
scaling = 1.5
if get_lcd_density() == 0:
  print("falling back to GRID UNIT scaling.")
  scaling = str(max(0.7, min(float(os.environ["GRID_UNIT_PX"])/scalingdevidor(), 2.4))) # cap at 2.4max and 0.7min so avoid croping issues.
else:
  scaling = str(max(0.7, min(float(get_lcd_density()/240), 2.4))) # cap at 2.4max and 0.7min so avoid croping issues. (DPI Scaling)

#### fluffychat env
os.environ["MOZ_USE_XINPUT2"] = "1"
#os.environ["GDK_SCALE"]=str(float(os.environ["GRID_UNIT_PX"]/8)) # old
os.environ["GDK_DPI_SCALE"]=scaling
os.environ["GTK_IM_MODULE"] = "Maliit"
os.environ["GTK_IM_MODULE_FILE"] = "lib/@CLICK_ARCH@/gtk-3.0/3.0.0/immodules/immodules.cache"

# Explicitly force X11 backend for GTK applications like Fluffychat (will remove when mir2.x subsurface support comes out)
os.environ["GDK_BACKEND"] = "x11" 
os.environ["DISABLE_WAYLAND"] = "1"

if len(sys.argv) > 1:
    url_to_open = sys.argv[1]
    # Pass the URL as an argument to librewolf
    # The first argument to execlp after the executable name is argv[0] for the new process,
    # so we repeat "bin/librewolf" and then add the actual arguments.
    os.execlp("./fluffychat", "fluffychat", url_to_open)
else:
    # If no URL is provided, just launch librewolf normally
    os.execlp("./fluffychat","fluffychat")