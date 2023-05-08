# Notes for ESP32

- ESP32 does only have serial ports 0-2 (where UART0 is used for stdout by default)
- You can run idf targets like `menuconfig` or `monitor` by specifing the target as an argument to the `build_firmware.sh` script
- The GPIO pins for the configured serial port can be set with `menuconfig` (see `micro-ROS Transport Settings` menu)
- ESP32 only runs in singlecore mode (`CONFIG_FREERTOS_UNICORE=y` setting)


# Notes for ESP32-CAMERA 

- SPIRAM is requierd only for ESP32-CAMERA and can cause a fatal error in ESP32 (Enable in  `menuconfig Component config > ESP32-specific` OR  add `CONFIG_ESP32_SPIRAM_SUPPORT=y` to `sdkconfig.defaults` file).
- Make sure that `rtc_gpio_desc` array is supported in `menuconfig: Component config > Driver configurations > RTCIO configuration` (set to TRUE)
  OR write this line `CONFIG_RTCIO_SUPPORT_RTC_GPIO_DESC=y` to `sdk.defaults`.
- Choose your camera pins configuration in `menuconfig Camera configuration > Camera pins`. (`BOARD_ESP32CAM_AITHINKER` is default).
- In order to view the images you will need to create a cv_bridge:
```
#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from cv_bridge import CvBridge, CvBridgeError
from sensor_msgs.msg import CompressedImage
import cv2
import numpy as np




class MinimalSubscriber(Node):

    def __init__(self, ):
        super().__init__('minimal_subscriber')
        self.subscription = self.create_subscription(CompressedImage, 'freertos_picture_publisher', self.listener_callback, 10)
        self.subscription  # prevent unused variable warning 
        self.bridge = CvBridge()
    def listener_callback(self, image_message):
        self.get_logger().info('recieved an image')
        
    	#recieve image and co nvert to cv2 image
        cv2.imshow('esp32_image', self.cv_image)
        cv2.waitKey(3)

        


def main(args=None):
    rclpy.init(args=args)
    minimal_subscriber = MinimalSubscriber()
    
    rclpy.spin(minimal_subscriber)
    minimal_subscriber.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
   main()


