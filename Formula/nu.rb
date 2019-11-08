class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://github.com/nulang/nu"
  url "https://github.com/nulang/nu/archive/v2.3.0.tar.gz"
  sha256 "1a6839c1f45aff10797dd4ce5498edaf2f04c415b3c28cd06a7e0697d6133342"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2488f52052cd0d8a204a505ee74f3ff81250b9c9011b0689717cb94e3f3461a" => :catalina
    sha256 "4926a4023c3f4c73ed601cc2d2fdd386e2e881e6696f7a796f157a89bf9a3c6d" => :mojave
    sha256 "01118b931054fc0ff14c56cd9d9de1effc1e2f8c9884c29ac5044e00657f6995" => :high_sierra
  end

  depends_on "pcre"

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
