Le fichier _tools/setup_env.sh_ automatise ces 4 étapes en une seule ligne.
====Au lieu de taper tout ça,====

- `conda deactivate` (si vous avez Anaconda d'installé, sinon ROS plante)
- `source /opt/ros/humble/setup.bash` (ou jazzy selon le PC du collègue)
- `colcon build --symlink-install`
- `source install/local_setup.bash`

====vous tapez juste====
`source tools/setup_env.sh`
