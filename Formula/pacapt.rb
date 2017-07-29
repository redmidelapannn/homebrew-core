class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.13.tar.gz"
  sha256 "078596bcbf6cb5e50abdeae2cf057432bccda5c716eb48fefdeee8da04998b7f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "83738ed14f58a6c93dc587664abfcfbfee2a6f9b68e9953497215a6617f470f1" => :sierra
    sha256 "83738ed14f58a6c93dc587664abfcfbfee2a6f9b68e9953497215a6617f470f1" => :el_capitan
    sha256 "83738ed14f58a6c93dc587664abfcfbfee2a6f9b68e9953497215a6617f470f1" => :yosemite
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
