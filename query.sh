:<<!
sh query.sh [all/nova/newdsp/mob/total/lu] [�Ʒ���] [��ʼʱ��] [����ʱ��/ȱʡ���ڿ�ʼʱ��]
����sh query.sh all 52005098_cpr 20160401 20160430
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

	while (( ${filename_day}<=${last_day} ))
	do
		file=${filename_dsp}"."${filename_day}
		# awk�в���ѡ�񣺣$0 all | $1 �Ʒ��� | $2 ���˱��� | $(NF-3) �����˵��  | $(NF-2) ���˵�� | $(NF-1) ���˺����� | $NF ԭʼ����
		temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$2"\t",$3"\t",$4"\t",$5"\t",$6"\t",$(NF-3)"\t",$(NF-2)"\t",$(NF-1)"\t",$NF"\t"}' ${file})
		echo -e "${filename_day}\t${temp}"
		(( filename_day++ ))
	done
	
	echo -e "\n"
}

query $1 $2 $3 $4
