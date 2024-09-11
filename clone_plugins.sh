#!/bin/bash


ASPACE_OMNIAUTH_CAS_VERSION="1.0.36"
ASPACE_LOCAL_VERSION="v1.0.8"
ASPACE_REFID_RULES_VERSION="v1.0.0"
ASPACE_HVD_PUI_VERSION="v2.5.4"
REQUEST_LIST_VERSION="1.2.8"
HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION="v0.17"
NLA_ACCESSION_REPORTS_VERSION="v2.5.02"
ASPACE_EAD_XFORM_VERSION="v2.0.7"
ASPACE_EVENT_CLEANUP_VERSION="v1.0.0"
HARVARD_ASPACE_REPORTS_VERSION="v0.1.51"
QUOTED_TYPES_FIX_VERSION="v0.1"

mkdir plugins
# ASpace Omniauth CAS will not work properly locally, this will clone it, but leave it out of the config.rb's plugins property unless otherwise desired
git clone -b $ASPACE_OMNIAUTH_CAS_VERSION https://github.com/harvard-lts/aspace-omniauth-cas.git ./plugins/aspace-omniauth-cas
git clone -b $ASPACE_LOCAL_VERSION https://github.com/harvard-lts/aspace-local.git ./plugins/local
git clone -b $ASPACE_REFID_RULES_VERSION https://github.com/harvard-lts/aspace-refid_rules.git ./plugins/refid_rules
git clone -b $ASPACE_HVD_PUI_VERSION https://github.com/harvard-lts/aspace-hvd-pui.git ./plugins/aspace-hvd-pui
git clone -b $REQUEST_LIST_VERSION https://github.com/harvard-lts/request_list.git ./plugins/request_list
git clone -b $HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION https://github.com/harvard-lts/harvard_request_list_customizations ./plugins/harvard_request_list_customizations
# aspace-jsonmodel-from-format is a lyrasis plugin so we just use their most updated main branch
git clone https://github.com/lyrasis/aspace-jsonmodel-from-format/ ./plugins/aspace-jsonmodel-from-format
git clone -b $NLA_ACCESSION_REPORTS_VERSION https://github.com/harvard-lts/nla_accession_reports ./plugins/nla_accession_reports
git clone -b $ASPACE_EAD_XFORM_VERSION https://github.com/harvard-lts/aspace-ead-xform ./plugins/aspace-ead-xform
git clone -b $ASPACE_EVENT_CLEANUP_VERSION https://github.com/harvard-lts/aspace-event-cleanup ./plugins/aspace-event-cleanup
git clone -b $HARVARD_ASPACE_REPORTS_VERSION https://github.com/harvard-lts/harvard_aspace_reports ./plugins/harvard_aspace_reports
git clone -b $QUOTED_TYPES_FIX_VERSION https://github.com/harvard-lts/quoted_types_fix.git ./plugins/quoted_types_fix
