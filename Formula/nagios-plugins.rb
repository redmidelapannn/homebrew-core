class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz"
  sha256 "4355b5daede0fa72bbb55d805d724dfa3d05e7f66592ad71b4e047c6d9cdd090"

  bottle do
    rebuild 1
    sha256 "9e10cb7170b2a7c1676f0c02789768e54cdbdcb75326a93e3e14228737a024fe" => :sierra
    sha256 "cab1ccf32b8b0e36d60ac0994d84ab735c2232549fdb2478be952cd445c5ae68" => :el_capitan
    sha256 "b4e1e14b3aefe8e03ec80c45a0155f579da3ed1d0d9d63a075bcaf4692ad7037" => :yosemite
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on :mysql => :optional

  conflicts_with "monitoring-plugins", :because => "monitoring-plugins ships their plugins to the same folder."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "google-public-dns", output
  end
end
