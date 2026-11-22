#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from stereo_msgs.msg import DisparityImage
from sensor_msgs.msg import Image
from cv_bridge import CvBridge
import cv2
import numpy as np

class DisparityConverter(Node):
    def __init__(self):
        super().__init__('disparity_converter')
        
        # On écoute le topic mathématique
        self.subscription = self.create_subscription(
            DisparityImage,
            'disparity',  # Topic relatif (s'adaptera au namespace /exo1 ou /exo2)
            self.listener_callback,
            10)
            
        # On publie l'image web
        self.publisher_ = self.create_publisher(Image, 'disparity_image', 10)
        self.bridge = CvBridge()
        self.get_logger().info("Disparity Converter Démarré ! En attente de données...")

    def listener_callback(self, msg):
        try:
            # Extraction de la matrice mathématique (32FC1) depuis le message ROS
            cv_image = self.bridge.imgmsg_to_cv2(msg.image, desired_encoding='passthrough')

            # On filtre les valeurs non valides (les zones où l'algo n'a pas pu calculer de profondeur)
            valid_pixels = cv_image[cv_image > 0]
            if len(valid_pixels) == 0:
                return # Si tout est noir, on ne fait rien

            # On cherche le point le plus proche et le point le plus loin
            min_disp = np.min(valid_pixels)
            max_disp = np.max(valid_pixels)

            # Normalisation (Transformation des mathématiques complexes en pixels de 0 à 255)
            if max_disp == min_disp:
                normalized = np.zeros_like(cv_image, dtype=np.uint8)
            else:
                normalized = 255.0 * (cv_image - min_disp) / (max_disp - min_disp)
                normalized = np.clip(normalized, 0, 255).astype(np.uint8)

            # Magie d'OpenCV : on applique un filtre thermique (Rouge = Proche, Bleu = Loin)
            color_image = cv2.applyColorMap(normalized, cv2.COLORMAP_JET)

            # Les zones d'erreur (inférieur à 0) restent en noir
            color_image[cv_image <= 0] = [0, 0, 0]

            # Reconversion en message ROS 2 (format bgr8 lisible par web_video_server)
            img_msg = self.bridge.cv2_to_imgmsg(color_image, encoding='bgr8')
            img_msg.header = msg.header # On garde l'heure exacte de la capture
            
            # On envoie l'image au navigateur !
            self.publisher_.publish(img_msg)

        except Exception as e:
            self.get_logger().error(f"Erreur de conversion : {e}")

def main(args=None):
    rclpy.init(args=args)
    node = DisparityConverter()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()