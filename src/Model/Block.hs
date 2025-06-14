{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Model.Block (
    BlockConfig(..)
  , Block(..)
  , blockInit
    , blockForward
) where

import GHC.Generics
import Torch
import Torch.NN as NN
import Torch.Functional as F
import Torch.Functional.Internal as FI

import Model.MLP
import Model.CasualSelfAttention
import Model.NormalLayer
import Config (modelDevice)




data BlockConfig = BlockConfig
    { embdDim_config :: Int,

    nHead_config :: Int,
    blockSize_config :: Int
    } deriving (Show, Eq)

data Block = Block
  { embdDim :: Int
    ,ln1 :: NormalLayer
    , attn :: CasualSelfAttention
    , ln2 :: NormalLayer
    , mlp :: MLP
  } deriving (Generic, Show,Parameterized)

blockInit :: BlockConfig -> IO Block
blockInit BlockConfig{..} = do
  ln1  <- normalLayerInit (NormalLayerConfig [embdDim_config] 1e-5 False)
  ln2  <- normalLayerInit (NormalLayerConfig [embdDim_config] 1e-5 False)
  attn <- casualSelfAttentionInit (CasualSelfAttentionConfig embdDim_config nHead_config blockSize_config)
  mlp  <- mlpInit (MLPConfig embdDim_config)
  let blk = Block
        { embdDim = embdDim_config
        , ln1      = ln1
        , attn     = attn
        , ln2      = ln2
        , mlp      = mlp
        }
  return (toDevice modelDevice blk)


     
  return Block
    { embdDim = embdDim_config
    , ln1 = ln1
    , attn = attn
    , ln2 = ln2
    , mlp = mlp

    }

blockForward
  :: Block
  -> Tensor
  -> Tensor
blockForward Block{..} x = let
    x1 = normalLayerForward ln1 x
    x2 = casualSelfAttentionForward attn x1
    x3 = normalLayerForward ln2 x2
    x4 = mlpForward mlp x3
    in 
     x4