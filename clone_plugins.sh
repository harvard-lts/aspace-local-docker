#!/bin/bash


ASPACE_OMNIAUTH_CAS_VERSION=1.0.35
ASPACE_LOCAL_VERSION=v1.0.5
ASPACE_REFID_RULES_VERSION=v1.0.0
ASPACE_HVD_PUI_VERSION=v2.4.7b
REQUEST_LIST_VERSION=1.2.8
HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION=v0.15
NLA_ACCESSION_REPORTS_VERSION=v2.5.02
ASPACE_EAD_XFORM_VERSION=v1.1.3
ASPACE_EVENT_CLEANUP_VERSION=v1.0.0
HARVARD_ASPACE_REPORTS_VERSION=v0.1.51
QUOTED_TYPES_FIX_VERSION=v0.1
BACKPORTS_302_VERSION=0.1

mkdir plugins
# ASpace Omniauth CAS will not work locally, so leave it out
# (I believe all bugs related to it were fixed during the attempted 2.8.1 upgrade)
# git clone -b $ASPACE_OMNIAUTH_CAS_VERSION https://github.com/harvard-library/aspace-omniauth-cas.git ./plugins/aspace-omniauth-cas
git clone -b $ASPACE_LOCAL_VERSION https://github.com/harvard-library/aspace-local.git ./plugins/local
git clone -b $ASPACE_REFID_RULES_VERSION https://github.com/harvard-library/aspace-refid_rules.git ./plugins/refid_rules
git clone -b $ASPACE_HVD_PUI_VERSION https://github.com/harvard-library/aspace-hvd-pui.git ./plugins/aspace-hvd-pui
git clone -b $REQUEST_LIST_VERSION https://github.com/harvard-library/request_list.git ./plugins/request_list
git clone -b $HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION https://github.com/harvard-library/harvard_request_list_customizations ./plugins/harvard_request_list_customizations
# aspace-jsonmodel-from-format is a lyrasis plugin so we just use their most updated main branch
git clone https://github.com/lyrasis/aspace-jsonmodel-from-format/ ./plugins/aspace-jsonmodel-from-format
git clone -b $NLA_ACCESSION_REPORTS_VERSION https://github.com/harvard-library/nla_accession_reports ./plugins/nla_accession_reports
git clone -b $ASPACE_EAD_XFORM_VERSION https://github.com/harvard-library/aspace-ead-xform ./plugins/aspace-ead-xform
git clone -b $ASPACE_EVENT_CLEANUP_VERSION https://github.com/harvard-library/aspace-event-cleanup ./plugins/aspace-event-cleanup
git clone -b $HARVARD_ASPACE_REPORTS_VERSION https://github.com/harvard-library/harvard_aspace_reports ./plugins/harvard_aspace_reports
git clone -b $QUOTED_TYPES_FIX_VERSION https://github.com/harvard-library/quoted_types_fix.git ./plugins/quoted_types_fix
git clone -b 0.1 https://github.com/harvard-lts/302-backports ./plugins/302-backports
