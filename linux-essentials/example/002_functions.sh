
create_host_project_dir () {
    mkdir -p ${BASE}/$1
    mkdir -p ${BASE}/$1/config
    mkdir -p ${BASE}/$1/properties

    touch ${BASE}/$1/properties/$1.properties
    touch ${BASE}/$1/config/$1.conf

    echo -e "\nhostname=$1\n====" > ${BASE}/$1/properties/$1.properties
    echo -e "\nhostname=$1\n====" >> ${BASE}/$1/properties/$1.properties
    echo -e "\nhostname=$1\n====" > ${BASE}/$1/config/$1.conf
    echo -e "\nhostname=$1\n====" >> ${BASE}/$1/config/$1.conf
}

assign_purpose () {
    mkdir -p ${BASE}/$1/properties/purpose
    touch ${BASE}/$1/properties/purpose/conf
    echo -e "${1}: ${2}" > ${BASE}/$1/properties/purpose/conf
}