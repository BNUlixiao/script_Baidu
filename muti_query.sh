# 计费名数组
array_cntname=(
)

# 时间区间（不支持跨月)
first_day=20160501
last_day=20160531

# 指定dsp：all/nova/newdsp/mob/total/lu
dsp=total

# --- 运行前请配置以上参数 ---

query(){
        dsp=$1
        cntname=$2
        first_day=$3

        if (( $#==3 ))
        then
                last_day=${first_day}
        else
                last_day=$4
        fi

        if (( ${last_day}-${first_day}>30 ))
        then
                echo "不支持数据跨月"
                exit 1
        fi

        if [ "${dsp}" = "all" ]
        then
                filename_dsp="para_cntname_filter"
        elif [ "${dsp}" = "nova" ]
        then
                filename_dsp="para_cpro_nova_cntname_filter"
        elif [ "${dsp}" = "newdsp" ]
        then
                filename_dsp="para_newdsp_cntname_filter"
        elif [ "${dsp}" = "mob" ]
        then
                filename_dsp="para_mob_cntname_filter"
	elif [ "${dsp}" = "total" ]
	then
		filename_dsp="total_cntname_filter"
	elif [ "${dsp}" = "lu" ]
	then
		filename_dsp="lu_cntname_filter"
        else
                echo "请指定dsp:all/nova/newdsp/mob/total/lu"
                exit 1
        fi

        filename_day=${first_day}

        echo -e "\n"${cntname}"_"${dsp}"_"${first_day}"to"${last_day}

        while (( ${filename_day}<=${last_day} ))
        do
                file=${filename_dsp}"."${filename_day}
                # awk中参数选择：0 all | $1 计费名 | $2 过滤比例 | $(NF-3) 被过滤点击  | $(NF-2) 过滤点击 | $(NF-1) 过滤后消费 | $NF 原始消费
                temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$2"\t",$3"\t",$4"\t",$5"\t",$6"\t",$(NF-3)"\t",$(NF-2)"\t",$(NF-1)"\t",$NF"\t"}' ${file})
                echo -e "${filename_day}\t${temp}"
                (( filename_day++ ))
        done

        echo -e "\n"
}

for cntname in ${array_cntname[@]}
do
	query ${dsp} ${cntname} ${first_day} ${last_day}
done
