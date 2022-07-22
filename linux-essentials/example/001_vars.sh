DO_ACTION=false
BASE="/work/school_of_devops"
HOST_ARRAY=(
    host_01
    host_02
    host_03
)

declare -A HOST_PURPOSE
HOST_PURPOSE=(
    [host_01]=frontend
    [host_02]=backend
    [host_03]=database
)