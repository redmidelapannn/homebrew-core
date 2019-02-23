class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.0.4/scons-3.0.4.tar.gz"
  sha256 "e2b8b36e25492720a05c0f0a92a219b42d11ce0c51e3397a1e8296dfea1d9b1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "36287e148d688b85d845a1fcc51fd30f0c7cd42dcade558d2884951f4a54bb4d" => :mojave
    sha256 "36287e148d688b85d845a1fcc51fd30f0c7cd42dcade558d2884951f4a54bb4d" => :high_sierra
    sha256 "c2ab4e69ec905f95ee90eb3cd052c33979c185e0ac9a98261080da394b1b77ee" => :sierra
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
