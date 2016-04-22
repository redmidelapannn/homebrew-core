class Cadubi < Formula
  desc "Test"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.7.2.tar.gz"
  sha256 "94f6e342daee4445f15db5a7440a11138487c49cc25da0c473bbf1b8978f5b79"

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    inreplace %w[ranger.py ranger/ext/rifle.py] do |s|
      s.gsub! "#!/usr/bin/python", "#!#{PythonRequirement.new.which_python}"
    end if MacOS.version <= :leopard

    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger -c exitcodecheck")
  end
end
