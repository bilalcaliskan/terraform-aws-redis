[redis]
%{ for ip in redis_instances ~}
${ip} ansible_user=${ansible_user} ansible_ssh_private_key_file=${private_key}
%{ endfor ~}
