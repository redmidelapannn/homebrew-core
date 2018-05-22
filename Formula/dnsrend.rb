class Dnsrend < Formula
  desc "DNS message dissector"
  homepage "http://romana.now.ie/dnsrend"
  url "http://romana.now.ie/software/dnsrend-0.08.tar.gz"
  sha256 "32fa6965f68e7090af7e4a9a06de53d12f40397f644a76cf97b6b4cb138da93a"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "0fe309917264a2f8370d0d12cff6c2a993a1d44bb7b8909b02f8384d3c734710" => :high_sierra
    sha256 "9c06b69b72b68d542d1e54326172c2c7e7800206d5fb6537d33ec68f661d06bc" => :sierra
    sha256 "044d790bf638c91c02c11807c0d35c409a4e24cb725e46f0e78cbe1f4d331300" => :el_capitan
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
