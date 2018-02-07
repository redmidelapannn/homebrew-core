class Icecream < Formula
  desc "Distributed compiler with a central scheduler to share build load"
  homepage "https://en.opensuse.org/Icecream"
  url "https://github.com/icecc/icecream/archive/1.1.tar.gz"
  sha256 "92532791221d7ec041b7c5cf9998d9c3ee8f57cbd2da1819c203a4c6799ffc18"

  bottle do
    rebuild 1
    sha256 "c604df6288036c9dc6445a27a713911acf95d420d15d59ad962715f38431def4" => :high_sierra
    sha256 "2577a254171a49a7da43e0276d42cda9610886d257dbf6901bf1605e2f0fdcd5" => :sierra
    sha256 "47b903820a8369d635b103a78c14a67ded9e37fa6de0b992f80dc966a1a9f4ad" => :el_capitan
  end

  option "with-docbook2X", "Build with man page"
  option "without-clang-wrappers", "Don't use symlink wrappers for clang/clang++"
  option "with-clang-rewrite-includes", "Use by default Clang's -frewrite-includes option"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lzo"
  depends_on "docbook2x" => [:optional, :build]

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-man" if build.without? "docbook2X"
    args << "--enable-clang-wrappers" if build.with? "clang-wrappers"
    args << "--enable-clang-write-includes" if build.with? "clang-rewrite-includes"

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

    (prefix/"org.opensuse.icecc.plist").write iceccd_plist
    (prefix/"org.opensuse.icecc-scheduler.plist").write scheduler_plist
  end

  def caveats; <<~EOS
    To override the toolset with icecc, add to your path:
      #{opt_libexec}/icecc/bin

    To have launchd start the icecc daemon at login:
      cp #{opt_prefix}/org.opensuse.icecc.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.opensuse.icecc.plist
    EOS
  end

  def iceccd_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Daemon</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/iceccd</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  def scheduler_plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>Icecc Scheduler</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{sbin}/icecc-scheduler</string>
        <string>-d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/gcc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", shell_output("./hello-c")

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system opt_libexec/"icecc/bin/g++", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", shell_output("./hello-cc")

    if build.with? "clang-wrappers"
      (testpath/"hello-clang.c").write <<~EOS
        #include <stdio.h>
        int main()
        {
          puts("Hello, world!");
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang", "-o", "hello-clang", "hello-clang.c"
      assert_equal "Hello, world!\n", shell_output("./hello-clang")

      (testpath/"hello-cclang.cc").write <<~EOS
        #include <iostream>
        int main()
        {
          std::cout << "Hello, world!" << std::endl;
          return 0;
        }
      EOS
      system opt_libexec/"icecc/bin/clang++", "-o", "hello-cclang", "hello-cclang.cc"
      assert_equal "Hello, world!\n", shell_output("./hello-cclang")
    end
  end
end
