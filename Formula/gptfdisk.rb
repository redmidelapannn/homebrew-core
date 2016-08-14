class Gptfdisk < Formula
  desc "Text-mode GPT partitioning tools"
  homepage "https://sourceforge.net/projects/gptfdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.1/gptfdisk-1.0.1.tar.gz"
  sha256 "864c8aee2efdda50346804d7e6230407d5f42a8ae754df70404dd8b2fdfaeac7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ffe675176707196449fb9388cffcee60612f8816e7d8d6ba9b8152622b8ff3" => :el_capitan
    sha256 "a03a7b079cd33ab644b0141ed4c756b8ceb2206530594742b997b35ead3e25b1" => :yosemite
    sha256 "b3e54a3696184a7b3d9ec2a0a0891eeb0950539280b10d32a82699bfe59e890d" => :mavericks
  end

  option "with-icu4c", "Use icu4c instead of internal functions for UTF-16 support. Use this if you are having problems with the new UTF-16 support."
  option "with-sgdisk", "Compile sgdisk."
  option "without-cgdisk", "Do not compile cgdisk."
  option "without-fixparts", "Do not compile fixparts."

  depends_on "icu4c" => :optional
  depends_on "popt" if build.with?("sgdisk")

  def install
    # Patch, upstream looks for wrong ncurses library
    inreplace "Makefile.mac", "/opt/local/lib/libncurses.a", "/usr/lib/libncurses.dylib"

    # Optional UTF-16 support from icu4c
    if build.with? "icu4c"
      inreplace "Makefile.mac", "-Wall", "-Wall -D USE_UTF16"
    end

    opts = ["gdisk"]
    opts << "sgdisk" if build.with? "sgdisk"
    opts << "cgdisk" if build.with? "cgdisk"
    opts << "fixparts" if build.with? "fixparts"

    system "make", "-f", "Makefile.mac", *opts
    sbin.install "gdisk"
    sbin.install "cgdisk" if build.with? "cgdisk"
    sbin.install "sgdisk" if build.with? "sgdisk"
    sbin.install "fixparts" if build.with? "fixparts"

    man8.install Dir["*.8"]
    doc.install Dir["*.html"]
  end

  test do
    assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/,
                 pipe_output("#{sbin}/gdisk", "\n")
  end
end
