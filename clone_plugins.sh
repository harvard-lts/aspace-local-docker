#!/bin/bash


# aspace-local, aspace-refid_rules, aspace_event_cleanup are currently unchanged.
# If they require updates, do so on a new updates_for_aspace_3_0_2 branch

ASPACE_OMNIAUTH_CAS_VERSION=changes_for_aspace_3_0_2
ASPACE_LOCAL_VERSION=main
ASPACE_REFID_RULES_VERSION=main
ASPACE_HVD_PUI_VERSION=updates_for_aspace_3_0_2
REQUEST_LIST_VERSION=changes_for_aspace_3_0_2
HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION=changes_for_aspace_3_0_2
ASPACE_ANDED_SEARCH_VERSION=master
NLA_ACCESSION_REPORTS_VERSION=changes_for_aspace_3_0_2
ASPACE_EAD_XFORM_VERSION=changes_for_aspace_3_0_2
ASPACE_EVENT_CLEANUP_VERSION=main
HARVARD_ASPACE_REPORTS_VERSION=updates_for_aspace_3_0_2

mkdir plugins
# ASpace Omniauth CAS will not work locally, so leave it out
# (I believe all bugs related to it were fixed during the attempted 2.8.1 upgrade)
# git clone -b $ASPACE_OMNIAUTH_CAS_VERSION https://github.com/harvard-library/aspace-omniauth-cas.git ./plugins/aspace-omniauth-cas
git clone -b $ASPACE_LOCAL_VERSION https://github.com/harvard-library/aspace-local.git ./plugins/local
git clone -b $ASPACE_REFID_RULES_VERSION https://github.com/harvard-library/aspace-refid_rules.git ./plugins/refid_rules
git clone -b $ASPACE_HVD_PUI_VERSION https://github.com/harvard-library/aspace-hvd-pui.git ./plugins/aspace-hvd-pui
git clone -b $REQUEST_LIST_VERSION https://github.com/harvard-library/request_list.git ./plugins/request_list
git clone -b $HARVARD_REQUEST_LIST_CUSTOMIZATIONS_VERSION https://github.com/harvard-library/harvard_request_list_customizations ./plugins/harvard_request_list_customizations
git clone -b $ASPACE_ANDED_SEARCH_VERSION https://github.com/harvard-library/aspace_anded_search ./plugins/aspace_anded_search
# aspace-jsonmodel-from-format is a lyrasis plugin so we just use their most updated main branch
git clone https://github.com/lyrasis/aspace-jsonmodel-from-format/ ./plugins/aspace-jsonmodel-from-format
git clone -b $NLA_ACCESSION_REPORTS_VERSION https://github.com/harvard-library/nla_accession_reports ./plugins/nla_accession_reports
git clone -b $ASPACE_EAD_XFORM_VERSION https://github.com/harvard-library/aspace-ead-xform ./plugins/aspace-ead-xform
git clone -b $ASPACE_EVENT_CLEANUP_VERSION https://github.com/harvard-library/aspace-event-cleanup ./plugins/aspace-event-cleanup
git clone -b $HARVARD_ASPACE_REPORTS_VERSION https://github.com/harvard-library/harvard_aspace_reports ./plugins/harvard_aspace_reports
