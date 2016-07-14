class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://files.pythonhosted.org/packages/06/96/93947d9be78aebb7985014fdf4d84896dd0f62514d922ee03f5bb55a21fb/asciinema-1.3.0.tar.gz"
  sha256 "acc1a07306c7af02cd9bc97c32e4748dbfa57ff11beb17fea64eaee67eaa2db3"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6805e73a3157eb8b0e50080c40fa4c95d2b73959ed796efca5fa4f77c83bfd63" => :el_capitan
    sha256 "249419336215f89f739519f7a0162e4dda966e5469bc2a5ef5bb28a50cc3d78b" => :yosemite
    sha256 "b3e1ee03c1036cae2dd3953ffaa0f8cafcbfc941c478b088f5bf0cc2672ee4c8" => :mavericks
  end

  depends_on :python3

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/asciinema --version")
  end
end
