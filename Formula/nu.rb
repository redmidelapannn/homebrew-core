class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://github.com/nulang/nu"
  url "https://github.com/nulang/nu/archive/v2.2.2.tar.gz"
  sha256 "7b1de5062ba2a87ee4cbf458f5f851a3c43473eec8aae3e17704e0dd4ff56b39"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dd4ad8f32f6dede0a197db5025971e1f49307c69ee4899f8d538f7f9fbb61183" => :mojave
    sha256 "8c5bc675f15111f4fa99aac6b83c1870988508e7f0d08cbe32ea9d420bdc9229" => :high_sierra
    sha256 "3edc9761b9cf8627e6843ec7b982130430822da765afe7219759070f5f8cf116" => :sierra
  end

  depends_on :macos => :lion
  depends_on "pcre"

  fails_with :gcc do
    build 5666
    cause "nu only builds with clang"
  end

  def install
    ENV.delete("SDKROOT") if MacOS.version < :sierra
    ENV["PREFIX"] = prefix

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!("\#{@destdir}/Library/Frameworks", "\#{@prefix}/Frameworks")
      s.sub! /^;; source files$/, <<~EOS
        ;; source files
        (set @framework_install_path "#{frameworks}")
      EOS
    end
    system "make"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats; <<~EOS
    Nu.framework was installed to:
      #{frameworks}/Nu.framework

    You may want to symlink this Framework to a standard macOS location,
    such as:
      ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
  EOS
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
