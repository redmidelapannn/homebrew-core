class Termsql < Formula
  desc "Convert text into SQL table and query it"
  homepage "https://tobimensch.github.io/termsql/"

  url "https://github.com/tobimensch/termsql/archive/22501e5c982ec04229643802e36756feb4687e89.tar.gz"
  version "22501e5c982ec04229643802e36756feb4687e89"
  sha256 "d8fabe96f57153a2e2852995d66f4506cf593bae4a6b9d7d76d3aef6150fb07e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a88b4c52475cb4976fb9547aaa6ad902b8dd4fe3bffcc55e796e6b00e12b338" => :sierra
    sha256 "780f13b15ef24881ced46432c8166df367aefd1d08cbe56ab6f4e72fbd6a7ded" => :el_capitan
    sha256 "780f13b15ef24881ced46432c8166df367aefd1d08cbe56ab6f4e72fbd6a7ded" => :yosemite
  end

  depends_on :python => ["sqlite3", "sqlparse"]

  def install
    # Replace path to man pages in hard-coded setup.py
    inreplace "setup.py", %r{/usr/share/man/man1/}, "#{man1}/"

    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    # Run an example query (count processes)
    assert_equal "bar", pipe_output("#{bin}/termsql 'select COL1 from tbl'", "foo bar baz").strip
  end
end
