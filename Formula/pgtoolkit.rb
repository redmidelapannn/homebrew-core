class Pgtoolkit < Formula
  desc "Tools for PostgreSQL maintenance"
  homepage "https://github.com/grayhemp/pgtoolkit"
  url "https://github.com/grayhemp/pgtoolkit/archive/v1.0.2.tar.gz"
  sha256 "d86f34c579a4c921b77f313d4c7efbf4b12695df89e6b68def92ffa0332a7351"

  # depends on system Perl, no other dependencies

  def install
    executables = [
      "pgcompact",
    ]

    docs = [
      "CHANGES.md",
      "LICENSE.md",
      "README.md",
      "TODO.md",
    ]

    executables.each { |executable| bin.install "fatpack/#{executable}" }
    docs.each { |document| doc.install document }
  end

  test do
    output = IO.popen("#{bin}/pgcompact --help")
    matches = output.readlines.select { |line| line =~ /pgcompact - PostgreSQL bloat reducing tool/ }

    !matches.empty?
  end
end
