# ���ڲ������Ʒ�����ʱ����ڵĹ��˱���������ʽ�����

# �Ʒ�������
array_cntname=(
)

# ʱ�����䣨��֧�ֿ���)
first_day=20160501
last_day=20160523

# ָ��dsp��all/nova/newdsp/mob
dsp=all

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
        else
                echo "��ָ��dsp:all/nova/newdsp/mob"
                exit 1
        fi

        filename_day=${first_day}

	echo -ne ${cntname}"|"

        while (( ${filename_day}<=${last_day} ))
        do
                file=${filename_dsp}"."${filename_day}
                temp=$(awk -v cntname="$cntname" -F '\t' '{if($1==cntname)print$2}' ${file})

		if [ "${temp}" = "" ]
		then
			temp="NA"
		fi

                echo -ne ${temp}"|"
                (( filename_day++ ))
        done

        echo -e "\n"
}

for cntname in ${array_cntname[@]}
do
	query ${dsp} ${cntname} ${first_day} ${last_day}
done
