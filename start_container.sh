if [ -z "$SUDO_USER" ]
then
      user=$USER
else
      user=$SUDO_USER
fi

xhost +local:root
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi
docker run -it --rm \
	--name=rrt_star_tb3 \
	--shm-size=1g \
	--ulimit memlock=-1 \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --privileged \
	--volume="/home/$user/ros/ros2_ws/Planning_algorithm_ws/:/root/Shared:rw" \
	--device=/dev/usb \
	--device=/dev/video0 \
	--env="XAUTHORITY=$XAUTH" \
	--volume="$XAUTH:$XAUTH" \
        --network=host \
	rrt_star_tb3 \
	bash

	#--gpus all \
	#--env="NVIDIA_VISIBLE_DEVICES=all" \
	#--env="NVIDIA_DRIVER_CAPABILITIES=all" \
