#
# spec file for package docker-tools
#
# Copyright (c) 2018 SUSE LINUX GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#


Name:           docker-tools
Version:        0.1
Release:        0
Summary:        Collection of scripts to ease operations on docker containers
License:        MIT
BuildArch:      noarch
Group:          Development/Tools/Other
Url:            https://github.com/iotbzh/docker-tools
Source:         %{name}-%{version}.tar.gz
BuildRequires:  systemd
Requires:       bridge-utils
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description
Collection of scripts to ease operations on docker containers,
and most notably to have containers with fixed IP addresses


%prep
%setup -q

%build
make %{?_smp_mflags}

%install
%make_install PREFIX=%{_prefix}

%post
exit 0

%postun
exit 0

%files
%defattr(-,root,root)
%config %{_sysconfdir}/docker-tools.conf
%{_unitdir}/docker@.service
%{_bindir}/*

%changelog
* Tue Jul 17 2018 <ronan.lemartret@iot.bzh> - 0.1-0
- Init packaging version
