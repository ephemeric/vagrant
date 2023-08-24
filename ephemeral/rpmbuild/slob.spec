Name:          slob
Version:       %{_version}
Release:       %{_release}
Summary:       slob
License:       Proprietary
URL:           https://slob.app
Vendor:        SLOB
Requires(pre): /usr/sbin/useradd
Requires:      bash >= 5.0.0
Conflicts:     slob
Packager:      Slob <support@%{name}.app>

%description
Slob.

# No prep, no build required.

%install
%define _pwd %(echo $PWD)

cd %{_pwd}

install -d $RPM_BUILD_ROOT/%{_bindir}
install -d $RPM_BUILD_ROOT/%{_sbindir}
install -d -m0700 $RPM_BUILD_ROOT/%{_var}/lib/%{name}
install -d $RPM_BUILD_ROOT/%{_sysconfdir}/default
install -d $RPM_BUILD_ROOT/%{_unitdir}
install -d $RPM_BUILD_ROOT/usr/share/doc/%{name}
install -m644 slob-init/%{name}.service $RPM_BUILD_ROOT/%{_unitdir}/%{name}.service
install -m644 slob-init/%{name} $RPM_BUILD_ROOT/etc/default/%{name}
install -m0755 slob_linux_x86_64 $RPM_BUILD_ROOT/%{_sbindir}/%{name}
install -m644 slob-init/LICENCE $RPM_BUILD_ROOT/usr/share/doc/%{name}/LICENCE
install -m644 slob-init/README $RPM_BUILD_ROOT/usr/share/doc/%{name}/README

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

%pre
getent group %{name} >/dev/null || groupadd -r %{name}
getent passwd %{name} >/dev/null || useradd -c "Slob User" -g %{name} -s /sbin/nologin -r -d /var/lib/%{name} %{name} 2>/dev/null || :

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service

%files
%defattr(0644,root,root)
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/default/%{name}
%attr(0700,%{name},%{name}) %{_var}/lib/%{name}
%attr(0644,root,root) %{_unitdir}/%{name}.service
%attr(0755,root,root) %{_sbindir}/%{name}
%license /usr/share/doc/slob/LICENCE
%doc /usr/share/doc/slob/README

%changelog
* Sat May 27 2023 Robert Gabriel <slob@ephemeric.lan>
- Add files.
