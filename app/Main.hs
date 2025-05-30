module Main (main) where

import Torch

import Model.GPT
import Utils (randInt)
import Data.Dataloader 
import qualified Config as C
import Train.Training


main :: IO ()
main = do
    putStrLn "Hello, Haskell!"
    -- configNEmbd configNBlock configVocabSize configNHead configBlockSize 

    tokens <- randintIO' 0 1000 [1000]
    save [tokens] "data/tokens/tokens1.pt"
    save [tokens] "data/tokens/tokens2.pt"
    save [tokens] "data/tokens/tokens3.pt"


    dataset <- randInt [1000] 0 C.vocabSize
    let dataloader = createDataLoader C.batchSize C.blockSize dataset
        

    model <- modelInit (ModelConfig C.nEmbd C.nBlock C.vocabSize C.nHead C.blockSize)

    let optimizer = mkAdam 0 C.beta1 C.beta2 (flattenParameters model)


    outmodel <- processEpoch model dataloader optimizer C.learningRate 





    print outmodel
    putStrLn "end of main"