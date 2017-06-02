class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.2/dovecot-2.2.30.1.tar.gz"
  mirror "https://fossies.org/linux/misc/dovecot-2.2.30.1.tar.gz"
  sha256 "9049db49f7ccd76850a17872896dfb8778676bab38454575f59bb39f16b083a4"

  bottle do
    rebuild 1
    sha256 "2f6605d8254d0024e6a04a18a3cdc0197c2590329b1d670132c5881b953ceb0b" => :sierra
    sha256 "0638bed9c81e8686b1b4fa41d50d22d4f4f694261a9564d8b408301fcc71973c" => :el_capitan
    sha256 "e9c52148ec2b06a35d7a65339ce27d7513ee7dfed777f6f49caa15c14572e318" => :yosemite
  end

  option "with-pam", "Build with PAM support"
  option "with-pigeonhole", "Add Sieve addon for Dovecot mailserver"
  option "with-pigeonhole-unfinished-features", "Build unfinished new Sieve addon features/extensions"
  option "with-stemmer", "Build with libstemmer support"

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "clucene" => :optional

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.2/dovecot-2.2-pigeonhole-0.4.18.tar.gz"
    sha256 "dd871bb57fad22795460f613f3c9484a8bf229272ac00956d837a34444f1c3a9"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
      :revision => "9ea5add413942d0aa2335cd8133c682263325ed8"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-ssl=openssl
      --with-ssldir=#{etc}/openssl
      --with-sqlite
      --with-zlib
      --with-bzlib
    ]

    args << "--with-lucene" if build.with? "clucene"
    args << "--with-pam" if build.with? "pam"

    if build.with? "stemmer"
      args << "--with-stemmer"

      resource("stemmer").stage do
        system "make", "dist_libstemmer_c"
        system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
        system "make", "-C", buildpath/"libstemmer_c"
        mv buildpath/"libstemmer_c/libstemmer.o", buildpath/"libstemmer_c/libstemmer.a"
        ENV.prepend "LDFLAGS", "-L#{buildpath}/libstemmer_c"
        ENV.prepend "CPPFLAGS", "-I#{buildpath}/libstemmer_c/include"
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "pigeonhole"
      resource("pigeonhole").stage do
        args = %W[
          --disable-dependency-tracking
          --with-dovecot=#{lib}/dovecot
          --prefix=#{prefix}
        ]

        args << "--with-unfinished-features" if build.with? "pigeonhole-unfinished-features"

        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end
  end

  def caveats; <<-EOS.undent
    For Dovecot to work, you may need to create a dovecot user
    and group depending on your configuration file options.
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dovecot</string>
          <string>-F</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/dovecot/dovecot.log</string>
        <key>SoftResourceLimits</key>
        <dict>
        <key>NumberOfFiles</key>
        <integer>1000</integer>
        </dict>
        <key>HardResourceLimits</key>
        <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")
  end
end
