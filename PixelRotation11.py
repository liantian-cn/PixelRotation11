import time
import random
import dxcam
from PIL import Image
import pyautogui

dx_camera = dxcam.create(device_idx=0, output_idx=0, output_color="RGB")

region = (0, 0, 32, 32)

dx_camera.start(region=region, video_mode=True, target_fps=120)

while True:
    frame = dx_camera.get_latest_frame()
    img = Image.fromarray(frame)
    pixel_color = img.getpixel((16, 16))

    if pixel_color == (255, 255, 255):
        print("闲置")
    elif pixel_color == (0, 0, 0):
        print("闲置")
    elif pixel_color == (0, 0, 128):
        print("死神的抚摩")
        pyautogui.press("num1")
    elif pixel_color == (0, 0, 255):
        print("精髓分裂")
        pyautogui.press("num2")
    elif pixel_color == (0, 128, 0):
        print("血液沸腾")
        pyautogui.press("num3")
    elif pixel_color == (0, 128, 128):
        print("灵界打击")
        pyautogui.press("num4")
    elif pixel_color == (0, 128, 255):
        print("死神印记")
        pyautogui.press("num5")
    elif pixel_color == (0, 255, 0):
        print("心脏打击")
        pyautogui.press("num6")
    elif pixel_color == (0, 255, 128):
        print("白骨风暴")
        pyautogui.press("num7")
    elif pixel_color == (0, 255, 255):
        print("吸血鬼之血")
        pyautogui.press("num8")
    elif pixel_color == (255, 0, 0):
        print("吞噬")
        pyautogui.press("num9")
    elif pixel_color == (255, 0, 128):
        print("墓石")
        pyautogui.press("add")
    elif pixel_color == (255, 0, 255):
        print("枯萎凋零")
        pyautogui.press("subtract")
    # print(pixel_color)
    time.sleep(random.uniform(0.2, 0.3))
1