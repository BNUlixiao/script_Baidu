:<<!
��ѯ�Ʒ�����ʱ����ڵ����ݣ�������Ϊ�����˵����ԭʼ��������˱��������˺����ѣ�ԭʼ����
sh sum_query.sh [all/nova/newdsp/mob/total/lu] [�Ʒ���] [��ʼʱ��] [����ʱ��/ȱʡ���ڿ�ʼʱ��]
����sh sum_query.sh all 52005098_cpr 20160401 20160430
��֧�����ݿ���
!

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

	echo -e "\n"${cntname}"_"${dsp}"_"${first_day}"to"${last_day}

	clc_filter=0
	clc_all=0
	spend_afterfilter=0
	spend_all=0

	while (( ${filename_day}<=${last_day} ))
	do
		file=${filename_dsp}"."${filename_day}
		
		# awk�в���ѡ�񣺣$0 all | $1 �Ʒ��� | $2 ���˱��� | $(NF-3) �����˵��  | $(NF-2) ���˵�� | $(NF-1) ���˺����� | $NF ԭʼ����
		clc_filter_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-3)}' ${file})
		clc_all_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-2)}' ${file})
		spend_afterfilter_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$(NF-1)}' ${file})
		spend_all_temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$NF}' ${file})
		
		clc_filter=$((clc_filter + clc_filter_temp))
		clc_all=$((clc_all + clc_all_temp))
		clc_filterrate=$(awk 'BEGIN{printf "%.2f%\n",('$clc_filter'/'$clc_all')*100}')
		spend_afterfilter=$(echo "$spend_afterfilter + $spend_afterfilter_temp" | bc)
		spend_all=$(echo "$spend_all + $spend_all_temp" | bc)
		
		(( filename_day++ ))
	done
	
	echo -e "${clc_filter}\t${clc_all}\t${clc_filterrate}\t${spend_afterfilter}\t${spend_all}"
}

query $1 $2 $3 $4
