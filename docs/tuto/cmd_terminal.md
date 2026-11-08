En ROS 2, à chaque fois que vous ouvrez un nouveau terminal, le terminal est "vierge" : il ne connaît ni les commandes ros2, ni vos packages compilés. Normalement, vous et vos collègues devriez taper à la main à chaque ouverture de terminal :

- `conda deactivate` (si vous avez Anaconda d'installé, sinon ROS plante)
- `source /opt/ros/humble/setup.bash` (ou jazzy selon le PC du collègue)
- `colcon build --symlink-install`
- `source install/local_setup.bash`
  ====Au lieu de taper tout ça,====

Le fichier tools/setup_env.sh automatise ces 4 étapes en une seule ligne.
vous tapez juste: `source tools/setup_env.sh` quand vous ouvrez votre terminal pour travailler sur un projet ROS 2 (ou Python avec .venv). Si c'est un petit projet simple sans ROS ni .venv, vous n'avez pas besoin de le lancer.
