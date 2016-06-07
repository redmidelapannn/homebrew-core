class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "https://media.luffy.cx/files/lldpd/lldpd-0.9.3.tar.gz"
  sha256 "cfa8a3245dd71efc1f5de064a72576a7c1afaaf0ccb5833238398b6dc612b127"

  bottle do
    revision 1
    sha256 "d3ba959f108942784ef0bd7e063d94a8bcf6d3ff8f30c71d1672efadc21dfcf0" => :el_capitan
    sha256 "b4db7b63d61985e1677d37421e7d6d0fb3f4f0bd8565b7118ec97d02602b737a" => :yosemite
    sha256 "e0e75a555822d18445974a9338b4ddbde884b7a67335593038b3c7c43b947f9b" => :mavericks
  end

  option "with-snmp", "Build SNMP subagent support"
  option "with-json", "Build JSON support for lldpcli"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libevent"
  depends_on "net-snmp" if build.with? "snmp"
  depends_on "jansson" if build.with? "json"

  def install
    readline = Formula["readline"]
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--localstatedir=#{var}",
      "--with-xml",
      "--with-readline",
      "--with-privsep-chroot=/var/empty",
      "--with-privsep-user=nobody",
      "--with-privsep-group=nogroup",
      "--with-launchddaemonsdir=no",
      "CPPFLAGS=-I#{readline.include} -DRONLY=1",
      "LDFLAGS=-L#{readline.lib}",
    ]
    args << (build.with?("snmp") ? "--with-snmp" : "--without-snmp")
    args << (build.with?("json") ? "--with-json" : "--without-json")

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :startup => true

  def plist
    additional_args = ""
    if build.with? "snmp"
      additional_args += "<string>-x</string>"
    end
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/lldpd</string>
        #{additional_args}
      </array>
      <key>RunAtLoad</key><true/>
      <key>KeepAlive</key><true/>
    </dict>
    </plist>
    EOS
  end
end
