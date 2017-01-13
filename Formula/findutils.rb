class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftpmirror.gnu.org/findutils/findutils-4.6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz"
  sha256 "ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d"

  bottle do
    rebuild 2
    sha256 "cf79481210bff82913cedd29b8baadc74f692e76562acbae07e599e39d3e63bb" => :sierra
    sha256 "e7bb9e49f32fd527aab82b226cc676aded051032e7fdeb4de839a3dc61627be2" => :el_capitan
    sha256 "d3f71df884ef43bcc37fdc7ad45a0e3ceede75cb6546943367cc7dda38a7275b" => :yosemite
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}/locate
      --disable-dependency-tracking
      --disable-debug
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    # https://savannah.gnu.org/bugs/index.php?46846
    # https://github.com/Homebrew/homebrew/issues/47791
    updatedb = (build.with?("default-names") ? "updatedb" : "gupdatedb")
    (libexec/"bin").install bin/updatedb
    (bin/updatedb).write <<-EOS.undent
      #!/bin/sh
      export LC_ALL='C'
      exec "#{libexec}/bin/#{updatedb}" "$@"
    EOS

    if build.without? "default-names"
      [[prefix, bin], [share, man/"*"]].each do |base, path|
        Dir[path/"g*"].each do |p|
          f = Pathname.new(p)
          gnupath = "gnu" + f.relative_path_from(base).dirname
          (libexec/gnupath).install_symlink f => f.basename.sub(/^g/, "")
        end
      end
    end
  end

  def caveats
    if build.without? "default-names"
      <<-EOS.undent
        All commands have been installed with the prefix 'g'.
        If you do not want the prefix, install using the "with-default-names" option.

        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"

        Additionally, you can access their man pages with normal names if you add
        the "gnuman" directory to your MANPATH from your bashrc as well:

            MANPATH="#{opt_libexec}/gnuman:$MANPATH"
      EOS
    end
  end

  plist_options :manual => (build.with?("default-names") ? "updatedb" : "gupdatedb")

  def plist
    updatedb = (build.with?("default-names") ? "updatedb" : "gupdatedb")
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{libexec}/bin/#{updatedb}</string>
          </array>
          <key>LowPriorityIO</key>
          <true/>
          <key>Nice</key>
          <integer>5</integer>
          <key>StandardErrorPath</key>
          <string>#{var}/log/updatedb.log</string>
          <key>StartCalendarInterval</key>
          <array>
              <dict>
                  <key>Hour</key>
                  <integer>3</integer>
                  <key>Minute</key>
                  <integer>15</integer>
                  <key>Weekday</key>
                  <integer>6</integer>
              </dict>
          </array>
        </dict>
      </plist>
    EOS
  end

  def post_install
    (var/"locate").mkpath
  end

  test do
    find = (build.with?("default-names") ? "find" : "gfind")
    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/#{find} .")
  end
end
