#!/bin/bash

# 检查源文件是否存在  
source_file="lagrange/Lagrange.OneBot"
if [ ! -f "$source_file" ]; then  
    echo "源文件 $source_file 不存在，正在复制..."  
    cp "Lagrange.OneBot" "$source_file"  
    if [ $? -eq 0 ]; then  
        echo "文件复制成功"  
        chmod +x lagrange/Lagrange.OneBot
    else  
        echo "文件复制失败"  
    fi  
else  
    echo "$source_file 已经存在"  
fi

supervisord -n -c /etc/supervisor/conf.d/supervisord.conf