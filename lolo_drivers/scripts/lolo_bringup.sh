SESSION=lolo_bringup

# Lidingo
UTM_ZONE=34
UTM_BAND=V

# Kristineberg
#UTM_ZONE=32
#UTM_BAND=V

# Rest of Sweden
#UTM_ZONE=33
#UTM_BAND=V

# IP Addresses to connect to neptus
# The IP of the computer running neptus
NEPTUS_IP=10.8.0.58 # Yi's computer
# IP of LOLO
LOLO_IP=10.8.0.30
# Port for the imc-ros-bridge, usually doesnt change from 6002.
BRIDGE_PORT=6002

tmux -2 new-session -d -s $SESSION

tmux rename-window "roscore"
tmux new-window -t $SESSION:1 -n 'core'
tmux new-window -t $SESSION:2 -n 'bt'
tmux new-window -t $SESSION:3 -n 'sidescan'

tmux select-window -t $SESSION:0
tmux send-keys "roscore" C-m

# start the gui and new_gui in one launch file 

tmux select-window -t $SESSION:1
tmux send-keys "roslaunch lolo_drivers lolo_core.launch utm_zone:=$UTM_ZONE utm_band:=$UTM_BAND"

tmux select-window -t $SESSION:2
tmux send-keys "roslaunch bt_mission mission.launch waypoint_tolerance:=5 neptus_addr:=$NEPTUS_IP bridge_addr:=$LOLO_IP bridge_port:=$BRIDGE_PORT robot_name:=lolo imc_id:=6 imc_system_name:=lolo"

tmux select-window -t $SESSION:3
tmux send-keys "roslaunch lolo_sidescan real.launch"

# Set default window
tmux select-window -t $SESSION:0

# Attach to session
tmux -2 attach-session -t $SESSION
