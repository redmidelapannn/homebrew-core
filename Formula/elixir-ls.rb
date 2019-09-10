class ElixirLs < Formula
  desc "Language Server Protocol implementation for Elixir"
  homepage "https://github.com/JakeBecker/elixir-ls"
  url "https://github.com/JakeBecker/elixir-ls/archive/v0.2.25.tar.gz"
  sha256 "48aef4a0e795627962bde7e9c5a4fd201f92ef816fc823738d6a1702ee911ee0"

  depends_on "elixir"

  def install
    # Ensure Hex and Rebar3 are installed
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"

    system "mix", "deps.get"
    system "mix", "compile"

    system "mix", "elixir_ls.release", "-o", prefix

    # Fix the launcher script
    # it depends on being in the same directory as .ez files
    bin.mkpath
    bin.install_symlink(
      prefix/"language_server.sh" => "elixir-language-server",
      prefix/"debugger.sh"        => "elixir-debugger",
    )
  end

  test do
    begin
      io = IO.popen("#{bin}/elixir-language-server", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS", io.read
    end

    begin
      io = IO.popen("#{bin}/elixir-debugger", "r+")
      io.write("\n")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)

      assert_match "Started ElixirLS debugger", io.read
    end
  end
end
