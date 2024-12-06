#!/bin/bash
SD_PATH=~/printer_data/gcodes
file_old=${SD_PATH}/${2}
file_new="back_${2}"
a=$(echo "${1} + 5" | bc)
new="${SD_PATH}/${file_new}"

# Parámetros dinámicos para X e Y
x_target=$3
y_target=$4

# Altura nueva
echo 'SET_KINEMATIC_POSITION Z='${1} > "${new}"
cat "${file_old}" | grep "^M190 S*" | tail -n 1 >> "${new}"
echo 'G91' >> "${new}"
echo 'G1 Z'${a} >> "${new}"
echo 'G90' >> "${new}"
echo 'G28 X Y' >> "${new}"
cat "${file_old}" | grep "^M104 S*" | tac | sed -n '2p' >> "${new}"
cat "${file_old}" | grep "^M109 S*" | tail -n 1 >> "${new}"
echo 'G21' >> "${new}"
echo 'G90' >> "${new}"
echo 'M83' >> "${new}"
echo 'M107' >> "${new}"
echo ';###################' >> "${new}"
echo ';###################' >> "${new}"
echo ';##### inicio ######' >> "${new}"
echo ';###################' >> "${new}"
echo 'G1 Z'${1} >> "${new}"
# Buscar el patrón dinámico y copiar desde la primera coincidencia con X e Y dadas
awk -v z=";Z:$1" '$0 ~ z {flag=1} flag' "${file_old}" >"borrar.txt"
awk -v x=${x_target} -v y=${y_target} '$0 ~ "G1 X"x" Y"y {found=1} found' borrar.txt >>${new}

# Confirmar al usuario
echo "Contenido copiado desde la línea con G1 X${x_target} Y${y_target} hacia abajo en ${new}"
