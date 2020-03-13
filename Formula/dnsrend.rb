class Dnsrend < Formula
  desc "DNS message dissector"
  homepage "https://lecter.redbrick.dcu.ie/dnsrend/"
  url "https://lecter.redbrick.dcu.ie/software/dnsrend-0.08.tar.gz"
  sha256 "32fa6965f68e7090af7e4a9a06de53d12f40397f644a76cf97b6b4cb138da93a"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "89ca4645bd4506859649de31d1b38d49f6e638bb3c23754dab1e25a9263396d9" => :catalina
    sha256 "6bffcd6096d851f155f97a99e00a75d9a2738ba51c9fa8bf18c5ee83bdd26ec1" => :mojave
    sha256 "abeca9fc47c5a600854c00a8e4ce1cbd99530c149dede5cf570ceb1e79dd7548" => :high_sierra
  end

  resource "Net::Pcap" do
    url "https://cpan.metacpan.org/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    sha256 "aaee41ebea17924abdc2d683ec940b3e6b0dc1e5e344178395f57774746a5452"
  end

  resource "Net::Pcap::Reassemble" do
    url "https://cpan.metacpan.org/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    sha256 "0bcba2d4134f6d412273a75663628b08b0a164e0a5ecb8a2fd14cdf5237629c4"
  end

  def install
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    libexec.install "dnsrend"
    doc.install "README"

    (bin/"dnsrend").write <<~EOS
      #!/bin/sh
      /usr/bin/env perl -Tw -I "#{libexec}/lib/perl5" #{libexec}/dnsrend "$@"
    EOS
  end

  test do
    system "#{bin}/dnsrend", test_fixtures("test.pcap")
  end
end
