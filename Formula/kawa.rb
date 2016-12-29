class Kawa < Formula
  desc "Programming language for Java (implementation of Scheme)"
  homepage "https://www.gnu.org/software/kawa/"
  url "https://ftpmirror.gnu.org/kawa/kawa-2.2.zip"
  mirror "https://ftp.gnu.org/gnu/kawa/kawa-2.2.zip"
  sha256 "eb2b8301786d5e983769c2e29ba7caf69afcb14977eac16d544471b9a3c79f79"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "11fc6035e8d804b8a685e2d2a75e9841d729201f8e4c703cf97147312a5ff62a" => :sierra
    sha256 "0adc35e64ba9641ee686b7cbf2e1adddc8eb9b5a19b08b6b330e236f2749ddba" => :el_capitan
    sha256 "0adc35e64ba9641ee686b7cbf2e1adddc8eb9b5a19b08b6b330e236f2749ddba" => :yosemite
  end

  depends_on :java

  def install
    rm_f Dir["bin/*.bat"]

    inreplace "bin/kawa" do |s|
      s.gsub! /thisfile=`type -p \$0`/, "thisfile=#{bin}/kawa"
      s.gsub! %r{\$kawadir/lib}, "$kawadir/libexec"
    end

    bin.install Dir["bin/*"]
    doc.install Dir["doc/*"]
    libexec.install Dir["lib/*"]
  end

  test do
    system bin/"kawa", "-e", "(import (srfi 1))"
  end
end
