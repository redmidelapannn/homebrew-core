class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.0.3/scons-3.0.3.tar.gz"
  sha256 "d8ec796b52586e269aec72c40b82289023c9ac9878c328bbf379a046460196f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "05dd0f52fe7ae212524ff6ee1cfe67f5e43fa21c42609835dd10b4ce2a7a2170" => :mojave
    sha256 "36bbd86c1db33fbfad8cc6a97c20d2ef7bdaa91e1cbe13fd503a3dc357c27abd" => :high_sierra
    sha256 "36bbd86c1db33fbfad8cc6a97c20d2ef7bdaa91e1cbe13fd503a3dc357c27abd" => :sierra
  end

  def install
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
