class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"
  revision 1

  bottle do
    rebuild 1
    sha256 "25ad3e78fe8a37d5553a9a623a2b9f9d08f8d80e15599927553d1d9322e59d2c" => :mojave
    sha256 "9baa75cd81724ba3031646bd7961a85ac5ab2ed167ee0e760eb4b112b708d2d6" => :high_sierra
    sha256 "ff4ef56442d8e50c071f9d6fde472e24a8675a8cdf237a4c65bd3967673fdb0c" => :sierra
  end

  conflicts_with "rename", :because => "both install `rename` binaries"

  def noshadow
    list =%w[ipcmk isosize mcookie namei rename scriptreplay setsid]
    list
  end

  def noshadow_sbin
    list =%w[blkid findfs fsck.cramfs fsck.minix mkfs mkfs.bfs mkfs.cramfs mkfs.minix mkswap swaplabel]
    list
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--program-prefix=l",
                          "--disable-ipcs",        # does not build on macOS
                          "--disable-ipcrm",       # does not build on macOS
                          "--disable-wall",        # already comes with macOS
                          "--disable-libuuid"      # conflicts with ossp-uuid

    system "make", "install"

    # Binaries not shadowing macOS utils symlinked without 'l' prefix
    # install completions only for installed programs
    noshadow.each do |cmd|
      bin.install_symlink "l#{cmd}" => cmd
      man1.install_symlink "l#{cmd}.1" => "#{cmd}.1"
      bash_completion.install cmd
    end

    # Binaries not shadowing macOS utils symlinked without 'l' prefix
    # install completions only for installed programs
    noshadow_sbin.each do |cmd|
      sbin.install_symlink "l#{cmd}" => cmd
      man1.install_symlink "l#{cmd}.1" => "#{cmd}.1"
      bash_completion.install cmd
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next unless File.executable?(path) && !File.directory?(path)

      cmd = path.basename.to_s.sub(/^l/, "")
      (libexec/"gnubin").install_symlink bin/"l#{cmd}" => cmd
      (libexec/"gnuman"/"man1").install_symlink man1/"l#{cmd}.1" => "#{cmd}.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    The following commands have been installed without the prefix 'l'.

        #{noshadow.sort.join("\n    ")}
        #{noshadow_sbin.sort.join("\n    ")}

    The rest of commands have been installed with the prefix to avoid shadowing
    existing macOS commands. If you really need to use the rest of the commands
    with their normal names, you can add a "gnubin" directory to your PATH from
    your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
