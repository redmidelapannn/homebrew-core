class ClosureLinter < Formula
  desc "Check JavaScript files for style and documentation"
  homepage "https://developers.google.com/closure/utilities/"
  url "https://github.com/google/closure-linter/archive/v2.3.19.tar.gz"
  sha256 "cd472f560be5af80afccbe94c9d9b534f7c30085510961ad408f8a314ea5c4c2"

  head "https://github.com/google/closure-linter.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7df1c30875724d8671001a28c57d4a057a0b43d56fa5561364dab7c0414bd543" => :high_sierra
    sha256 "7df1c30875724d8671001a28c57d4a057a0b43d56fa5561364dab7c0414bd543" => :sierra
    sha256 "4282c3d187d6ff3d2438778c75e96fb56aa5d6c74e35f6da7b491e13e616f7de" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  def install
    ENV["PYTHONPATH"] = libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*js*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.js").write("var test = 1;\n")
    assert_equal "1 files checked, no errors found.", shell_output("#{bin}/gjslint test.js").chomp
    system "#{bin}/fixjsstyle", "test.js"
  end
end
