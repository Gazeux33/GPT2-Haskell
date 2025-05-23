module DataTest where

import Test.Hspec
import Utils (randInt)
import Data.Dataloader (createDataLoader)
import Torch hiding (div)



testDataloaderLength :: Spec
testDataloaderLength = do
    let batchSize = 8
        seqLen = 10
        
    it "test length dataloader" $ do
        input <- randInt [1000] 0 10
        let dataloader = createDataLoader batchSize seqLen input
        length dataloader `shouldBe` (1000 - seqLen) `div` batchSize


testDataloaderSizeFirstItem :: Spec
testDataloaderSizeFirstItem = do
    let batchSize = 8
        seqLen = 10
        
    it "test size of the first item" $ do
        input <- randInt [1000] 0 10
        let dataloader = createDataLoader batchSize seqLen input
            (x, y) = head dataloader
        shape x `shouldBe` [batchSize, seqLen]
        shape y `shouldBe` [batchSize, seqLen]


testDataloaderSizeLastItem :: Spec
testDataloaderSizeLastItem = do
    let batchSize = 8
        seqLen = 10
        
    it "test size of the last item" $ do
        input <- randInt [1000] 0 10
        let dataloader = createDataLoader batchSize seqLen input
            (x, y) = last dataloader
        shape x `shouldBe` [batchSize, seqLen]
        shape y `shouldBe` [batchSize, seqLen]







