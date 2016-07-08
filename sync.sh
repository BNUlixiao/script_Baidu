:<<!
sh sync.sh [all/nova/newdsp/mob/total/lu] [��ʼʱ��] [����ʱ��]
����sh sync.sh all 20160401 20160430
��֧�����ݿ���
!




sync(){
	dsp=$1
        first_day=$2

        if (( $#==2 ))
        then
                last_day=${first_day}
        else
                last_day=$3
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

	while (( ${filename_day}<=${last_day} ))
	do
		file=${filename_dsp}"."${filename_day}
		wget ftp://cq01-anti-rd04.cq01.baidu.com//home/work/cpro_offline/case_analysis/data/${filename_day}/${file}
		((filename_day++))
	done
}
sync $1 $2 $3
