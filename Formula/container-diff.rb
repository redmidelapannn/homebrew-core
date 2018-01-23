class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.5.2.tar.gz"
  sha256 "9f64267b01e9f96efd053eadbac6435bdb15c05597e8ebe4e7081e13fb7e45cf"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleCloudPlatform").mkpath
    ln_sf buildpath, buildpath/"src/github.com/GoogleCloudPlatform/container-diff"

    cd "src/github.com/GoogleCloudPlatform/container-diff" do
      system "make"
      bin.install "out/container-diff"
    end
  end

  test do
    expected = <<~EOS
      -----Apt-----

      Packages found in docker/whalesay:
      NAME                               VERSION                                 SIZE
      -adduser                           3.113 nmu3ubuntu3                       644K
      -apt                               1.0.1ubuntu2.7                          3.5M
      -apt-utils                         1.0.1ubuntu2.7                          668K
      -base-files                        7.2ubuntu5.2                            433K
      -base-passwd                       3.5.33                                  252K
      -bash                              4.3-7ubuntu1.5                          1.5M
      -bsdutils                          1:2.20.1-5.1ubuntu20.4                  194K
      -busybox-initramfs                 1:1.21.0-1ubuntu1                       357K
      -bzip2                             1.0.6-5                                 119K
      -ca-certificates                   20141019ubuntu0.14.04.1                 452K
      -console-setup                     1.70ubuntu8                             1.5M
      -coreutils                         8.21-1ubuntu5.1                         5.9M
      -cpio                              2.11 dfsg-1ubuntu1.1                    312K
      -cron                              3.0pl1-124ubuntu2                       300K
      -dash                              0.5.7-4ubuntu1                          228K
      -debconf                           1.5.51ubuntu2                           609K
      -debconf-i18n                      1.5.51ubuntu2                           1.1M
      -debianutils                       4.4                                     283K
      -dh-python                         1.20140128-1ubuntu8                     309K
      -diffutils                         1:3.3-1                                 428K
      -dmsetup                           2:1.02.77-6ubuntu2                      181K
      -dpkg                              1.17.5ubuntu5.4                         6.1M
      -e2fslibs                          1.42.9-3ubuntu1.2                       401K
      -e2fsprogs                         1.42.9-3ubuntu1.2                       2.4M
      -eject                             2.1.5 deb1+cvs20081104-13.1             160K
      -file                              1:5.14-2ubuntu3.3                       98K
      -findutils                         4.4.2-7                                 816K
      -gcc-4.8-base                      4.8.2-19ubuntu1                         212K
      -gcc-4.9-base                      4.9.1-0ubuntu1                          213K
      -git                               1:1.9.1-1ubuntu0.1                      19.3M
      -git-man                           1:1.9.1-1ubuntu0.1                      1.2M
      -gnupg                             1.4.16-1ubuntu2.3                       1.6M
      -gpgv                              1.4.16-1ubuntu2.3                       443K
      -grep                              2.16-1                                  712K
      -gzip                              1.6-3ubuntu1                            236K
      -hostname                          3.15ubuntu1                             69K
      -ifupdown                          0.7.47.2ubuntu4.1                       234K
      -init-system-helpers               1.14                                    76K
      -initramfs-tools                   0.103ubuntu4.2                          365K
      -initramfs-tools-bin               0.103ubuntu4.2                          121K
      -initscripts                       2.88dsf-41ubuntu6.1                     224K
      -insserv                           1.14.0-5ubuntu2                         183K
      -iproute2                          3.12.0-2                                1.1M
      -iputils-ping                      3:20121221-4ubuntu1.1                   159K
      -isc-dhcp-client                   4.2.4-7ubuntu12.1                       1.8M
      -isc-dhcp-common                   4.2.4-7ubuntu12.1                       1.7M
      -kbd                               1.15.5-1ubuntu1                         1M
      -keyboard-configuration            1.70ubuntu8                             2.2M
      -klibc-utils                       2.0.3-0ubuntu1                          387K
      -kmod                              15-0ubuntu6                             282K
      -krb5-locales                      1.12 dfsg-2ubuntu5.1                    2.6M
      -less                              458-2                                   288K
      -libacl1                           2.2.52-1                                76K
      -libapt-inst1.5                    1.0.1ubuntu2.7                          735K
      -libapt-pkg4.12                    1.0.1ubuntu2.7                          2.8M
      -libarchive-extract-perl           0.70-1                                  100K
      -libasn1-8-heimdal                 1.6~git20131207 dfsg-1ubuntu1.1         803K
      -libattr1                          1:2.4.47-1ubuntu1                       56K
      -libaudit-common                   1:2.3.2-2ubuntu1                        44K
      -libaudit1                         1:2.3.2-2ubuntu1                        144K
      -libblkid1                         2.20.1-5.1ubuntu20.4                    248K
      -libbsd0                           0.6.0-2ubuntu1                          145K
      -libbz2-1.0                        1.0.6-5                                 113K
      -libc-bin                          2.19-0ubuntu6.6                         3.4M
      -libc6                             2.19-0ubuntu6.6                         10.2M
      -libcap2                           1:2.24-0ubuntu2                         57K
      -libcap2-bin                       1:2.24-0ubuntu2                         99K
      -libcgmanager0                     0.24-0ubuntu7.3                         145K
      -libcomerr2                        1.42.9-3ubuntu1.2                       103K
      -libcurl3-gnutls                   7.35.0-1ubuntu2.5                       525K
      -libdb5.3                          5.3.28-3ubuntu3                         1.7M
      -libdbus-1-3                       1.6.18-0ubuntu4.3                       379K
      -libdebconfclient0                 0.187ubuntu1                            85K
      -libdevmapper1.02.1                2:1.02.77-6ubuntu2                      301K
      -libdrm2                           2.4.56-1~ubuntu2                        106K
      -libedit2                          3.1-20130712-2                          236K
      -liberror-perl                     0.17-1.1                                80K
      -libestr0                          0.1.9-0ubuntu2                          49K
      -libexpat1                         2.1.0-4ubuntu1                          390K
      -libffi6                           3.1~rc1 r3.0.13-12                      70K
      -libfribidi0                       0.19.6-1                                136K
      -libgcc1                           1:4.9.1-0ubuntu1                        129K
      -libgcrypt11                       1.5.3-2ubuntu4.2                        587K
      -libgdbm3                          1.8.3-12build1                          107K
      -libgnutls-openssl27               2.12.23-12ubuntu2.2                     276K
      -libgnutls26                       2.12.23-12ubuntu2.2                     1M
      -libgpg-error0                     1.12-0.2ubuntu1                         92K
      -libgssapi-krb5-2                  1.12 dfsg-2ubuntu5.1                    403K
      -libgssapi3-heimdal                1.6~git20131207 dfsg-1ubuntu1.1         323K
      -libhcrypto4-heimdal               1.6~git20131207 dfsg-1ubuntu1.1         281K
      -libheimbase1-heimdal              1.6~git20131207 dfsg-1ubuntu1.1         126K
      -libheimntlm0-heimdal              1.6~git20131207 dfsg-1ubuntu1.1         103K
      -libhx509-5-heimdal                1.6~git20131207 dfsg-1ubuntu1.1         369K
      -libidn11                          1.28-1ubuntu2                           367K
      -libjson-c2                        0.11-3ubuntu1.2                         86K
      -libjson0                          0.11-3ubuntu1.2                         29K
      -libk5crypto3                      1.12 dfsg-2ubuntu5.1                    303K
      -libkeyutils1                      1.5.6-1                                 51K
      -libklibc                          2.0.3-0ubuntu1                          128K
      -libkmod2                          15-0ubuntu6                             130K
      -libkrb5-26-heimdal                1.6~git20131207 dfsg-1ubuntu1.1         649K
      -libkrb5-3                         1.12 dfsg-2ubuntu5.1                    987K
      -libkrb5support0                   1.12 dfsg-2ubuntu5.1                    163K
      -libldap-2.4-2                     2.4.31-1 nmu2ubuntu8                    507K
      -liblocale-gettext-perl            1.05-7build3                            92K
      -liblockfile-bin                   1.09-6ubuntu1                           71K
      -liblockfile1                      1.09-6ubuntu1                           57K
      -liblog-message-simple-perl        0.10-1                                  56K
      -liblzma5                          5.1.1alpha 20120614-2ubuntu2            305K
      -libmagic1                         1:5.14-2ubuntu3.3                       2.7M
      -libmodule-pluggable-perl          5.1-1                                   87K
      -libmount1                         2.20.1-5.1ubuntu20.4                    246K
      -libmpdec2                         2.4.0-6                                 256K
      -libncurses5                       5.9 20140118-1ubuntu1                   292K
      -libncursesw5                      5.9 20140118-1ubuntu1                   374K
      -libnewt0.52                       0.52.15-2ubuntu5                        188K
      -libnih-dbus1                      1.0.3-4ubuntu25                         70K
      -libnih1                           1.0.3-4ubuntu25                         148K
      -libp11-kit0                       0.20.2-2ubuntu2                         317K
      -libpam-cap                        1:2.24-0ubuntu2                         68K
      -libpam-modules                    1.1.8-1ubuntu2                          840K
      -libpam-modules-bin                1.1.8-1ubuntu2                          225K
      -libpam-runtime                    1.1.8-1ubuntu2                          300K
      -libpam0g                          1.1.8-1ubuntu2                          225K
      -libpcre3                          1:8.31-2ubuntu2                         463K
      -libplymouth2                      0.8.8-0ubuntu17.1                       302K
      -libpng12-0                        1.2.50-1ubuntu2                         305K
      -libpod-latex-perl                 0.61-1                                  127K
      -libpopt0                          1.16-8ubuntu1                           128K
      -libprocps3                        1:3.3.9-1ubuntu2.2                      138K
      -libpython3-stdlib                 3.4.0-0ubuntu2                          52K
      -libpython3.4-minimal              3.4.0-2ubuntu1                          3.2M
      -libpython3.4-stdlib               3.4.0-2ubuntu1                          9.1M
      -libreadline6                      6.3-4ubuntu2                            404K
      -libroken18-heimdal                1.6~git20131207 dfsg-1ubuntu1.1         158K
      -librtmp0                          2.4 20121230.gitdf6c518-1               143K
      -libsasl2-2                        2.1.25.dfsg1-17build1                   166K
      -libsasl2-modules                  2.1.25.dfsg1-17build1                   229K
      -libsasl2-modules-db               2.1.25.dfsg1-17build1                   82K
      -libselinux1                       2.2.2-1ubuntu0.1                        193K
      -libsemanage-common                2.2-1                                   56K
      -libsemanage1                      2.2-1                                   263K
      -libsepol1                         2.2-1ubuntu0.1                          322K
      -libslang2                         2.2.4-15ubuntu1                         1.4M
      -libsqlite3-0                      3.8.2-1ubuntu2                          838K
      -libss2                            1.42.9-3ubuntu1.2                       115K
      -libssl1.0.0                       1.0.1f-1ubuntu2.11                      2.9M
      -libstdc++6                        4.8.2-19ubuntu1                         1.2M
      -libtasn1-6                        3.4-3ubuntu0.2                          130K
      -libterm-ui-perl                   0.42-1                                  78K
      -libtext-charwidth-perl            0.04-7build3                            75K
      -libtext-iconv-perl                1.7-5build2                             85K
      -libtext-soundex-perl              3.4-1build1                             80K
      -libtext-wrapi18n-perl             0.06-7                                  68K
      -libtinfo5                         5.9 20140118-1ubuntu1                   471K
      -libudev1                          204-5ubuntu20.11                        132K
      -libusb-0.1-4                      2:0.1.12-23.3ubuntu1                    73K
      -libustr-1.0-1                     1.0.4-3ubuntu2                          266K
      -libuuid1                          2.20.1-5.1ubuntu20.4                    109K
      -libwind0-heimdal                  1.6~git20131207 dfsg-1ubuntu1.1         230K
      -libx11-6                          2:1.6.2-1ubuntu2                        1.5M
      -libx11-data                       2:1.6.2-1ubuntu2                        1.5M
      -libxau6                           1:1.0.8-1                               50K
      -libxcb1                           1.10-2ubuntu1                           181K
      -libxdmcp6                         1:1.1.1-1                               71K
      -libxext6                          2:1.3.2-1ubuntu0.0.14.04.1              121K
      -libxmuu1                          2:1.1.1-1                               65K
      -locales                           2.13 git20120306-12.1                   8.9M
      -lockfile-progs                    0.1.17                                  78K
      -login                             1:4.1.5.1-1ubuntu9                      1.1M
      -logrotate                         3.8.7-1ubuntu1                          159K
      -lsb-base                          4.1 Debian11ubuntu6                     82K
      -lsb-release                       4.1 Debian11ubuntu6                     120K
      -makedev                           2.3.1-93ubuntu1                         125K
      -mawk                              1.3.3-17ubuntu2                         197K
      -mime-support                      3.54ubuntu1.1                           143K
      -module-init-tools                 15-0ubuntu6                             31K
      -mount                             2.20.1-5.1ubuntu20.4                    421K
      -mountall                          2.53                                    262K
      -multiarch-support                 2.19-0ubuntu6.6                         202K
      -ncurses-base                      5.9 20140118-1ubuntu1                   367K
      -ncurses-bin                       5.9 20140118-1ubuntu1                   523K
      -net-tools                         1.60-25ubuntu2.1                        708K
      -netbase                           5.2                                     66K
      -netcat-openbsd                    1.105-7ubuntu1                          109K
      -ntpdate                           1:4.2.6.p5 dfsg-3ubuntu2.14.04.3        241K
      -openssh-client                    1:6.6p1-2ubuntu2                        3.4M
      -openssl                           1.0.1f-1ubuntu2.11                      906K
      -passwd                            1:4.1.5.1-1ubuntu9                      2.3M
      -patch                             2.7.1-4ubuntu2                          220K
      -perl                              5.18.2-2ubuntu1                         16.9M
      -perl-base                         5.18.2-2ubuntu1                         4.7M
      -perl-modules                      5.18.2-2ubuntu1                         15.8M
      -plymouth                          0.8.8-0ubuntu17.1                       457K
      -procps                            1:3.3.9-1ubuntu2.2                      680K
      -python3                           3.4.0-0ubuntu2                          100K
      -python3-minimal                   3.4.0-0ubuntu2                          139K
      -python3.4                         3.4.0-2ubuntu1                          325K
      -python3.4-minimal                 3.4.0-2ubuntu1                          4M
      -readline-common                   6.3-4ubuntu2                            109K
      -resolvconf                        1.69ubuntu1.1                           245K
      -rsync                             3.1.0-2ubuntu0.1                        634K
      -rsyslog                           7.4.4-1ubuntu2.5                        1.5M
      -sed                               4.2.2-4ubuntu1                          304K
      -sensible-utils                    0.0.9                                   110K
      -sudo                              1.8.9p5-1ubuntu1.1                      1.5M
      -sysv-rc                           2.88dsf-41ubuntu6.1                     221K
      -sysvinit-utils                    2.88dsf-41ubuntu6.1                     242K
      -tar                               1.27.1-1                                784K
      -tzdata                            2015d-0ubuntu0.14.04                    1.5M
      -ubuntu-keyring                    2012.05.19                              46K
      -ubuntu-minimal                    1.325                                   60K
      -ucf                               3.0027 nmu1                             229K
      -udev                              204-5ubuntu20.11                        5M
      -upstart                           1.12.1-0ubuntu4.2                       1.6M
      -ureadahead                        0.100.0-16                              124K
      -util-linux                        2.20.1-5.1ubuntu20.4                    1.6M
      -vim-common                        2:7.4.052-1ubuntu3                      317K
      -vim-tiny                          2:7.4.052-1ubuntu3                      931K
      -whiptail                          0.52.15-2ubuntu5                        85K
      -xauth                             1:1.0.7-1ubuntu1                        86K
      -xkb-data                          2.10.1-1ubuntu1                         2.8M
      -zlib1g                            1:1.2.8.dfsg-1ubuntu1                   171K
    EOS
    output = shell_output("#{bin}/container-diff analyze docker/whalesay")
    assert_match expected, output
  end
end
