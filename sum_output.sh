# ���ڲ������Ʒ�����ʱ����ڵĹ��˱���������ʽ�������output.txt

# �Ʒ�������
array_cntname=(
22029121_cpr
73013154_cpr
94008184_cpr
39056120_cpr
34021174_cpr
85029194_cpr
)

# ʱ�����䣨��֧�ֿ���)
first_day=20160706
last_day=20160711

# ָ��dsp��all/nova/newdsp/mob/total/lu
dsp=total

# --- ����ǰ���������ϲ��� ---

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
                echo "��֧�����ݿ���"
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
                echo "��ָ��dsp:all/nova/newdsp/mob/total/lu"
                exit 1
        fi

        filename_day=${first_day}

	echo -ne ${cntname}"|" >> output.txt
	# echo -ne ${cntname}

	clc_filter=0
	clc_all=0
	spend_afterfilter=0
	spend_all=0

	while (( ${filename_day}<=${last_day} ))
	do
		file=${filename_dsp}"."${filename_day}
		
		# awk�в���ѡ��?0 all | $1 �Ʒ��� | $2 ���˱��� | $(NF-3) �����˵��  | $(NF-2) ���˵�� | $(NF-1) ���˺����� | $NF ԭʼ����
		clc_filter_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-3)}' ${file})
		clc_filter_temp=${clc_filter_temp:-0}
		clc_all_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-2)}' ${file})
		clc_all_temp=${clc_all_temp:-0}
		spend_afterfilter_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-1)}' ${file})
		spend_afterfilter_temp=${spend_afterfilter_temp:-0}
		spend_all_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$NF}' ${file})
		spend_all_temp=${spend_all_temp:-0}
		
		clc_filter=$((clc_filter + clc_filter_temp))
		clc_all=$((clc_all + clc_all_temp))
		spend_afterfilter=$(echo "$spend_afterfilter + $spend_afterfilter_temp" | bc)
		spend_all=$(echo "$spend_all + $spend_all_temp" | bc)
		
		(( filename_day++ ))
	done

	clc_filterrate=$(awk 'BEGIN{printf "%.2f%\n",('$clc_filter'/'$clc_all')*100}')
	
	echo -ne "${clc_filter}|${clc_all}|${clc_filterrate}|${spend_afterfilter}|${spend_all}" >> output.txt

        echo -e "\n" >> output.txt
	# echo -e "\n"
}

for cntname in ${array_cntname[@]}
do
	query ${dsp} ${cntname} ${first_day} ${last_day}
done
