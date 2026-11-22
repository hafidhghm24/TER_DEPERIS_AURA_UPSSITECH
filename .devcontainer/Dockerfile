FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Installation des outils système et dépendances ExoMy
RUN apt-get update && apt-get install -y \
    sudo \
    python3-pip \
    ros-humble-gazebo-ros \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-msgs \
    ros-humble-gazebo-plugins \
    ros-humble-xacro \
    ros-humble-rosbridge-suite \
    ros-humble-web-video-server \
    ros-humble-robot-localization \
    ros-humble-stereo-image-proc \
    ros-humble-cv-bridge \
    ros-humble-foxglove-bridge \
    ros-humble-rtabmap-ros \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Création de l'utilisateur (UID 1000)
ARG USERNAME=ros_user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Configuration de l'environnement de l'utilisateur
USER $USERNAME
ENV SHELL=/bin/bash

# Ajout des sources au démarrage du terminal
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc && \
    echo "source /workspaces/exomy-container/install/setup.bash" >> ~/.bashrc

# Aide Gazebo à trouver les modèles d'ExoMy
ENV GAZEBO_MODEL_PATH=/workspaces/exomy-container/install/exomy_sim/share/exomy_sim/models:$GAZEBO_MODEL_PATH