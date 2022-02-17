{ config, pkgs, ... }:
let
  uwu-vim = pkgs.vimUtils.buildVimPlugin {
    name = "uwu.vim";
    src = pkgs.fetchFromGitHub {
      owner = "mangeshrex";
      repo = "uwu.vim";
      rev = "2b91dd9f817b3fba898b51492c404f136e11576c";
      sha256 = "08jlxr49kgf6ckm0fk7ilnz0iviffkg02bh18wvhmyc63sz2304i";
    };
  };
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "henning";
  home.homeDirectory = "/Users/henning";

  # Packages to install
  home.packages = with pkgs; [
    jq
    curl
    httpie
    tree
    pstree
    colorls
    bat
    git
    mitmproxy
    zsh
    ripgrep
    fd
    ruby_3_0
    gradle
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      filetype on
      syntax on
      filetype plugin indent on
      
      set relativenumber
      set cursorline
      set scrolloff=20
      set colorcolumn=81
      set mouse=a

      set termguicolors
      set background=dark

      set tabstop=2
      set shiftwidth=2
      set expandtab

      set splitbelow
      set splitright

      set clipboard+=unnamedplus

      let mapleader="\<space>"

      inoremap jj <esc>|
      nnoremap <up> <nop>
      nnoremap <down> <nop>
      nnoremap <left> <nop>
      nnoremap <right> <nop>

      nnoremap <leader>ff :Telescope find_files<cr>
      nnoremap <leader>fg :Telescope live_grep<cr>
      nnoremap <leader>fs :Telescope grep_string<cr>
      nnoremap <leader>fc :Telescope git_commits<cr>

      nnoremap <C-j> :cn<cr>
      nnoremap <C-k> :cp<cr>
      nnoremap <C-w> :cclose<cr>

      nnoremap <leader>r :vsp<cr>
      nnoremap <leader>b :split<cr>

      autocmd BufNewFile,BufRead Fastfile set filetype=ruby
      autocmd BufNewFile,BufRead Gemfile set filetype=ruby
      autocmd BufNewFile,BufRead Podfile set filetype=ruby
    '';
    plugins = with pkgs.vimPlugins; let theme = "nightfox"; in [
      { plugin = (nvim-treesitter.withPlugins
          (_: pkgs.tree-sitter.allGrammars)
        );
        config = ''
          lua << END
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true
            }
          }
          END
        '';
      }
      ( if theme == "nightfox" then
          { plugin = nightfox-nvim;
            config = ''
              colorscheme nightfox
            '';
          }
        else if theme == "uwu" then
          { plugin = uwu-vim;
            config = ''
              colorscheme uwu
            '';
          }
        else
          { plugin = ayu-vim;
            config = ''
              colorscheme ayu
            '';
          }
      )
      { plugin = lualine-nvim;
        config = ''
          lua << END
          require'lualine'.setup {
            options = {
              theme = "${theme}",
              section_separators = { left = "", right = "" },
              component_separators = { left = "|", right = "|" }
            }
          }
          END
        '';
      }
      { plugin = comment-nvim;
        config = ''
          lua << END
          require('Comment').setup()
          END
        '';
      }
      { plugin = telescope-nvim;
        config = ''
          lua << END
          require('telescope').setup()
          END
        '';
      }
      { plugin = nvim-lspconfig;
        config = ''
          lua << END
          local nvim_lsp = require('lspconfig')

          local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true }
            buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          end

          local servers = { 'solargraph' }
          for _,lsp in ipairs(servers) do
            nvim_lsp[lsp].setup {
              on_attach = on_attach
            }
          end
          END
        '';
      }
      cmp-nvim-lsp
      # cmp-buffer
      # cmp-path
      # cmp-cmdline
      { plugin = nvim-cmp;
        config = ''
          lua << END
          local cmp = require'cmp'
          local nvim_lsp = require('lspconfig')

          cmp.setup({
            mapping = {
              ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
              ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.close(),
              ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' }
            })
          })

          local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
          local servers = { 'solargraph' }
          for _,lsp in ipairs(servers) do
            nvim_lsp[lsp].setup {
              capabilities = capabilities
            }
          end
          END
        '';
      }
      plenary-nvim
      nvim-web-devicons
    ];
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };
  
  # Raw configuration files
  home.file.".gitconfig".source = ./gitconfig;
  home.file.".zshrc".source = ./zshrc;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
