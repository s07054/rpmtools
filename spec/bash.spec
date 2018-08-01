Summary: bash
Name: bash
Version: 0.1
Release: 1
Group: bash
License: bash
Source: %{expand:%%(pwd)}
BuildRoot: %{_topdir}/BUILD/%{name}-%{version}-%{release}

%description
%{summary}

%prep
rm -rf $RPM_BUILD_ROOT
cd $RPM_BUILD_ROOT
touch ./bin/bash

%clean
rm -r -f "$RPM_BUILD_ROOT"

%files
%defattr(755,root,root)
%{_bindir}/bash

