pragma solidity 0.7.6;

import "./libraries/BasicMaths.sol";
import "./interfaces/ISystemSettings.sol";
import "./interfaces/IPool.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract SystemSettings is ISystemSettings, Ownable {
    using SafeMath for uint256;
    using BasicMaths for uint256;
    using BasicMaths for bool;

    mapping(address => PoolSetting) private _poolSettings;
    mapping(address => uint256) private _debtSettings;
    mapping(uint32 => bool) private _leverages;
    uint256 private _marginRatio;
    uint256 private _protocolFee;
    uint256 private _liqProtocolFee;
    uint256 private _closingFee;
    uint256 private _liqFeeBase;
    uint256 private _liqFeeMax;
    uint256 private _liqFeeCoefficient;
    uint256 private _liqLsRequire;
    uint256 private _rebaseCoefficient;
    uint256 private _imbalanceThreshold;
    uint256 private _priceDeviationCoefficient;
    uint256 private _minHoldingPeriod;
    uint256 private _debtStart;
    uint256 private _debtAll;
    uint256 private _minDebtRepay;
    uint256 private _maxDebtRepay;
    uint256 private _interestRate;
    uint256 private _liquidityCoefficient;
    bool private _deviation;

    uint256 private constant E4 = 1e4;
    uint256 private constant E18 = 1e18;
    uint256 private constant E38 = 1e38;

    bool private _active;
    address private _official;
    address private _deployer02;

    constructor(address deployer02) {
        _official = msg.sender;
        _deployer02 = deployer02;
    }

    function official() external view override returns (address) {
        return _official;
    }

    function deployer02() external view override returns (address) {
        return _deployer02;
    }

    function requireSystemActive() external view override {
        require(_active, "system is suspended");
    }

    function resumeSystem() external override onlyOwner {
        _active = true;
        emit Resume(msg.sender);
    }

    function suspendSystem() external override onlyOwner {
        _active = false;
        emit Suspend(msg.sender);
    }

    function protocolFee() external view override returns (uint256) {
        return _protocolFee;
    }

    function liqProtocolFee() external view override returns (uint256) {
        return _liqProtocolFee;
    }

    function leverageExist(uint32 leverage_)
        external
        view
        override
        returns (bool)
    {
        return _leverages[leverage_];
    }

    function marginRatio() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _marginRatio;
        } else {
            return poolSetting.marginRatio;
        }
    }

    function closingFee() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _closingFee;
        } else {
            return poolSetting.closingFee;
        }
    }

    function liqFeeBase() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _liqFeeBase;
        } else {
            return poolSetting.liqFeeBase;
        }
    }

    function liqFeeMax() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _liqFeeMax;
        } else {
            return poolSetting.liqFeeMax;
        }
    }

    function liqFeeCoefficient() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _liqFeeCoefficient;
        } else {
            return poolSetting.liqFeeCoefficient;
        }
    }

    function liqLsRequire() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _liqLsRequire;
        } else {
            return poolSetting.liqLsRequire;
        }
    }

    function rebaseCoefficient() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _rebaseCoefficient;
        } else {
            return poolSetting.rebaseCoefficient;
        }
    }

    function imbalanceThreshold() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _imbalanceThreshold;
        } else {
            return poolSetting.imbalanceThreshold;
        }
    }

    function priceDeviationCoefficient()
        external
        view
        override
        returns (uint256)
    {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _priceDeviationCoefficient;
        } else {
            return poolSetting.priceDeviationCoefficient;
        }
    }

    function minHoldingPeriod() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _minHoldingPeriod;
        } else {
            return poolSetting.minHoldingPeriod;
        }
    }

    function debtStart() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _debtStart;
        } else {
            return poolSetting.debtStart;
        }
    }

    function debtAll() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _debtAll;
        } else {
            return poolSetting.debtAll;
        }
    }

    function minDebtRepay() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _minDebtRepay;
        } else {
            return poolSetting.minDebtRepay;
        }
    }

    function maxDebtRepay() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _maxDebtRepay;
        } else {
            return poolSetting.maxDebtRepay;
        }
    }

    function interestRate() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _interestRate;
        } else {
            return poolSetting.interestRate;
        }
    }

    function liquidityCoefficient() external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _liquidityCoefficient;
        } else {
            return poolSetting.liquidityCoefficient;
        }
    }

    function deviation() external view override returns (bool) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _deviation;
        } else {
            return poolSetting.deviation;
        }
    }

    function checkOpenPosition(uint16 level) external view override {
        require(_active, "system is suspended");
        require(_leverages[level], "Leverage Not Exist");
    }

    function mulClosingFee(uint256 value)
        external
        view
        override
        returns (uint256)
    {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _closingFee.mul(value) / E4;
        } else {
            return poolSetting.closingFee.mul(value) / E4;
        }
    }

    function mulLiquidationFee(uint256 margin, uint256 deltaBlock)
        external
        view
        override
        returns (uint256)
    {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];

        uint256 liqRatio;
        if (poolSetting.owner == address(0)) {
            if (_liqFeeBase == _liqFeeMax) {
                return _liqFeeBase.mul(margin) / E4;
            }

            liqRatio = deltaBlock.mul(_liqFeeMax.sub(_liqFeeBase)) / _liqFeeCoefficient + _liqFeeBase;
            if (liqRatio < _liqFeeMax) {
                return liqRatio.mul(margin) / E4;
            } else {
                return _liqFeeMax.mul(margin) / E4;
            }
        } else {
            if (poolSetting.liqFeeBase == poolSetting.liqFeeMax) {
                return poolSetting.liqFeeBase.mul(margin) / E4;
            }

            liqRatio = deltaBlock.mul(poolSetting.liqFeeMax.sub(poolSetting.liqFeeBase)) / poolSetting.liqFeeCoefficient + poolSetting.liqFeeBase;
            if (liqRatio < poolSetting.liqFeeMax) {
                return liqRatio.mul(margin) / E4;
            } else {
                return poolSetting.liqFeeMax.mul(margin) / E4;
            }
        }
    }

    function mulMarginRatio(uint256 margin)
        external
        view
        override
        returns (uint256)
    {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return _marginRatio.mul(margin) / E4;
        } else {
            return poolSetting.marginRatio.mul(margin) / E4;
        }
    }

    function mulProtocolFee(uint256 amount)
        external
        view
        override
        returns (uint256)
    {
        return _protocolFee.mul(amount) / E4;
    }

    function mulLiqProtocolFee(uint256 amount)
        external
        view
        override
        returns (uint256)
    {
        return _liqProtocolFee.mul(amount) / E4;
    }

    function meetImbalanceThreshold(
        uint256 nakedPosition,
        uint256 liquidityPool
    ) external view override returns (bool) {
        uint256 D = (nakedPosition).mul(E4) / liquidityPool;

        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return D > _imbalanceThreshold;
        } else {
            return D > poolSetting.imbalanceThreshold;
        }
    }

    function mulImbalanceThreshold(uint256 liquidityPool)
        external
        view
        override
        returns (uint256)
    {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return liquidityPool.mul(_imbalanceThreshold) / E4;
        } else {
            return liquidityPool.mul(poolSetting.imbalanceThreshold) / E4;
        }
    }

    function calRebaseDelta(
        uint256 rebaseSizeXBlockDelta,
        uint256 imbalanceSize
    ) external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return rebaseSizeXBlockDelta.mul(E18).div(_rebaseCoefficient).div(imbalanceSize);
        } else {
            return rebaseSizeXBlockDelta.mul(E18).div(poolSetting.rebaseCoefficient).div(imbalanceSize);
        }
    }

    function calDeviation(uint256 nakedPosition, uint256 liquidityPool)
        external
        view
        override
        returns (uint256)
    {
        uint256 D = nakedPosition.mul(E18) / liquidityPool;
        // Maximum deviation is 1e18
        require(D < E38, "Maximum deviation is 100%");

        uint256 deviationResult;
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            deviationResult = (D.pow() / E18).mul(
                _priceDeviationCoefficient
            ) / E4;
        } else {
            deviationResult = (D.pow() / E18).mul(
                poolSetting.priceDeviationCoefficient
            ) / E4;
        }

        // Maximum deviation is 1e18
        require(deviationResult < E18, "Maximum deviation is 100%");
        return deviationResult;
    }

    function calDebtRepay(
        uint256 lsPnl,
        uint256 totalDebtWithInterest,
        uint256 totalLiquidity
    ) external view override returns (uint256 repay) {

        uint256 minRepay;
        uint256 maxRepay;
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            minRepay = lsPnl.mul(_minDebtRepay) / E4;
            maxRepay = lsPnl.mul(_maxDebtRepay) / E4;
        } else {
            minRepay = lsPnl.mul(poolSetting.minDebtRepay) / E4;
            maxRepay = lsPnl.mul(poolSetting.maxDebtRepay) / E4;
        }

        repay = totalDebtWithInterest.pow().mul(lsPnl) / totalLiquidity.pow();

        if (repay < minRepay) {
            repay = minRepay;
        }

        if (repay > maxRepay) {
            repay = maxRepay;
        }

        if (repay > totalDebtWithInterest) {
            repay = totalDebtWithInterest;
        }

        return repay;
    }

    function calDebtIssue(
        uint256 tdPnl,
        uint256 lsAvgPrice,
        uint256 lsPrice
    ) external view override returns (uint256) {

        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            if (lsPrice.mul(E4) >= lsAvgPrice.mul(_debtStart)) {
                return 0;
            }

            if (lsPrice.mul(E4) <= lsAvgPrice.mul(_debtAll)) {
                return tdPnl;
            }
        } else {
            if (lsPrice.mul(E4) >= lsAvgPrice.mul(poolSetting.debtStart)) {
                return 0;
            }

            if (lsPrice.mul(E4) <= lsAvgPrice.mul(poolSetting.debtAll)) {
                return tdPnl;
            }
        }

        return lsAvgPrice.sub(lsPrice).pow().mul(tdPnl) / lsAvgPrice.pow();
    }

    function mulInterestFromDebt(
        uint256 amount
    ) external view override returns (uint256) {
        uint256 interestRateFromDebt = _debtSettings[msg.sender];
        if (interestRateFromDebt == 0) {
            return amount.mul(_interestRate) / E4;
        } else {
            return amount.mul(interestRateFromDebt) / E4;
        }
    }

    function divInterestFromDebt(
        uint256 amount
    ) external view override returns (uint256) {
        uint256 interestRateFromDebt = _debtSettings[msg.sender];
        if (interestRateFromDebt == 0) {
            return amount.mul(E4) / _interestRate;
        } else {
            return amount.mul(E4) / interestRateFromDebt;
        }
    }

    function mulLiquidityCoefficient(
        uint256 nakedPositions
    ) external view override returns (uint256) {
        PoolSetting memory poolSetting = _poolSettings[msg.sender];
        if (poolSetting.owner == address(0)) {
            return nakedPositions.mul(E4).div(_liquidityCoefficient);
        } else {
            return nakedPositions.mul(E4).div(poolSetting.liquidityCoefficient);
        }
    }

    function setProtocolFee(uint256 protocolFee_) external onlyOwner {
        _protocolFee = protocolFee_;
        emit SetSystemParam(systemParam.ProtocolFee, protocolFee_);
    }

    function setLiqProtocolFee(uint256 liqProtocolFee_) external onlyOwner {
        _liqProtocolFee = liqProtocolFee_;
        emit SetSystemParam(systemParam.LiqProtocolFee, liqProtocolFee_);
    }

    function setMarginRatio(uint256 marginRatio_) external onlyOwner {
        _marginRatio = marginRatio_;
        emit SetSystemParam(systemParam.MarginRatio, _marginRatio);
    }

    function setClosingFee(uint256 closingFee_) external onlyOwner {
        _closingFee = closingFee_;
        emit SetSystemParam(systemParam.ClosingFee, _closingFee);
    }

    function setLiqFeeBase(uint256 liqFeeBase_) external onlyOwner {
        require(_liqFeeMax > liqFeeBase_, "liqFeeMax must > liqFeeBase");
        _liqFeeBase = liqFeeBase_;
        emit SetSystemParam(systemParam.LiqFeeBase, _liqFeeBase);
    }

    function setLiqFeeMax(uint256 liqFeeMax_) external onlyOwner {
        require(liqFeeMax_ > _liqFeeBase, "liqFeeMax must > liqFeeBase");
        _liqFeeMax = liqFeeMax_;
        emit SetSystemParam(systemParam.LiqFeeMax, liqFeeMax_);
    }

    function setLiqFeeCoefficient(uint256 liqFeeCoefficient_) external onlyOwner {
        _liqFeeCoefficient = liqFeeCoefficient_;
        emit SetSystemParam(systemParam.LiqFeeCoefficient, _liqFeeCoefficient);
    }

    function setLiqLsRequire(uint256 liqLsRequire_) external onlyOwner {
        _liqLsRequire = liqLsRequire_;
        emit SetSystemParam(systemParam.LiqLsRequire, liqLsRequire_);
    }

    function addLeverage(uint32 leverage_) external onlyOwner {
        _leverages[leverage_] = true;
    }

    function deleteLeverage(uint32 leverage_) external onlyOwner {
        _leverages[leverage_] = false;
    }

    function setRebaseCoefficient(uint256 rebaseCoefficient_)
        external
        onlyOwner
    {
        _rebaseCoefficient = rebaseCoefficient_;
        emit SetSystemParam(systemParam.RebaseCoefficient, _rebaseCoefficient);
    }

    function setImbalanceThreshold(uint256 imbalanceThreshold_)
        external
        onlyOwner
    {
        _imbalanceThreshold = imbalanceThreshold_;
        emit SetSystemParam(
            systemParam.ImbalanceThreshold,
            _imbalanceThreshold
        );
    }

    function setPriceDeviationCoefficient(uint256 priceDeviationCoefficient_)
        external
        onlyOwner
    {
        _priceDeviationCoefficient = priceDeviationCoefficient_;
        emit SetSystemParam(
            systemParam.PriceDeviationCoefficient,
            _priceDeviationCoefficient
        );
    }

    function setMinHoldingPeriod(uint256 minHoldingPeriod_)
        external
        onlyOwner
    {
        _minHoldingPeriod = minHoldingPeriod_;
        emit SetSystemParam(
            systemParam.MinHoldingPeriod,
            _minHoldingPeriod
        );
    }

    function setDebtStart(uint256 debtStart_)
        external
        onlyOwner
    {
        _debtStart = debtStart_;
        emit SetSystemParam(
            systemParam.DebtStart,
            _debtStart
        );
    }

    function setDebtAll(uint256 debtAll_)
        external
        onlyOwner
    {
        _debtAll = debtAll_;
        emit SetSystemParam(
            systemParam.DebtAll,
            _debtAll
        );
    }

    function setMinDebtRepay(uint256 minDebtRepay_)
        external
        onlyOwner
    {
        _minDebtRepay = minDebtRepay_;
        emit SetSystemParam(
            systemParam.MinDebtRepay,
            _minDebtRepay
        );
    }

    function setMaxDebtRepay(uint256 maxDebtRepay_)
        external
        onlyOwner
    {
        _maxDebtRepay = maxDebtRepay_;
        emit SetSystemParam(
            systemParam.MaxDebtRepay,
            _maxDebtRepay
        );
    }

    function setInterestRate(uint256 interestRate_)
        external
        onlyOwner
    {
        _interestRate = interestRate_;
        emit SetSystemParam(
            systemParam.InterestRate,
            _interestRate
        );
    }

    function setLiquidityCoefficient(uint256 liquidityCoefficient_)
        external
        onlyOwner
    {
        _liquidityCoefficient = liquidityCoefficient_;
        emit SetSystemParam(
            systemParam.LiquidityCoefficient,
            _liquidityCoefficient
        );
    }

    function setDeviation(bool deviation_) external onlyOwner {
        _deviation = deviation_;
        emit SetDeviation(_deviation);
    }

    /*--------------------------------------------------------------------------------------------------*/

    function setMarginRatioByPool(address pool, uint256 marginRatio_) external onlyPoolOwner(pool) {
        _poolSettings[pool].marginRatio = marginRatio_;
        emit SetPoolParam(pool, systemParam.MarginRatio, marginRatio_);
    }

    function setClosingFeeByPool(address pool, uint256 closingFee_) external onlyPoolOwner(pool) {
        _poolSettings[pool].closingFee = closingFee_;
        emit SetPoolParam(pool, systemParam.ClosingFee, closingFee_);
    }

    function setLiqFeeBaseByPool(address pool, uint256 liqFeeBase_) external onlyPoolOwner(pool) {
        require(_poolSettings[pool].liqFeeMax > liqFeeBase_, "liqFeeMax must > liqFeeBase");
        _poolSettings[pool].liqFeeBase = liqFeeBase_;
        emit SetPoolParam(pool, systemParam.LiqFeeBase, liqFeeBase_);
    }

    function setLiqFeeMaxByPool(address pool, uint256 liqFeeMax_) external onlyPoolOwner(pool) {
        require(liqFeeMax_ > _poolSettings[pool].liqFeeBase, "liqFeeMax must > liqFeeBase");
        _poolSettings[pool].liqFeeMax = liqFeeMax_;
        emit SetPoolParam(pool, systemParam.LiqFeeMax, liqFeeMax_);
    }

    function setLiqFeeCoefficientByPool(address pool, uint256 liqFeeCoefficient_) external onlyPoolOwner(pool) {
        _poolSettings[pool].liqFeeCoefficient = liqFeeCoefficient_;
        emit SetPoolParam(pool, systemParam.LiqFeeCoefficient, liqFeeCoefficient_);
    }

    function setLiqLsRequireByPool(address pool, uint256 liqLsRequire_) external onlyPoolOwner(pool) {
        _poolSettings[pool].liqLsRequire = liqLsRequire_;
        emit SetPoolParam(pool, systemParam.LiqLsRequire, liqLsRequire_);
    }

    function setRebaseCoefficientByPool(address pool, uint256 rebaseCoefficient_) external onlyPoolOwner(pool) {
        _poolSettings[pool].rebaseCoefficient = rebaseCoefficient_;
        emit SetPoolParam(pool, systemParam.RebaseCoefficient, rebaseCoefficient_);
    }

    function setImbalanceThresholdByPool(address pool, uint256 imbalanceThreshold_) external onlyPoolOwner(pool) {
        _poolSettings[pool].imbalanceThreshold = imbalanceThreshold_;
        emit SetPoolParam(pool, systemParam.ImbalanceThreshold, imbalanceThreshold_);
    }

    function setPriceDeviationCoefficientByPool(address pool, uint256 priceDeviationCoefficient_) external onlyPoolOwner(pool) {
        _poolSettings[pool].priceDeviationCoefficient = priceDeviationCoefficient_;
        emit SetPoolParam(pool, systemParam.PriceDeviationCoefficient, priceDeviationCoefficient_);
    }

    function setMinHoldingPeriodByPool(address pool, uint256 minHoldingPeriod_) external onlyPoolOwner(pool) {
        _poolSettings[pool].minHoldingPeriod = minHoldingPeriod_;
        emit SetPoolParam(pool, systemParam.MinHoldingPeriod, minHoldingPeriod_);
    }

    function setDebtStartByPool(address pool, uint256 debtStart_) external onlyPoolOwner(pool) {
        _poolSettings[pool].debtStart = debtStart_;
        emit SetPoolParam(pool, systemParam.DebtStart, debtStart_);
    }

    function setDebtAllByPool(address pool, uint256 debtAll_) external onlyPoolOwner(pool) {
        _poolSettings[pool].debtAll = debtAll_;
        emit SetPoolParam(pool, systemParam.DebtAll, debtAll_);
    }

    function setMinDebtRepayByPool(address pool, uint256 minDebtRepay_) external onlyPoolOwner(pool) {
        _poolSettings[pool].minDebtRepay = minDebtRepay_;
        emit SetPoolParam(pool, systemParam.MinDebtRepay, minDebtRepay_);
    }

    function setMaxDebtRepayByPool(address pool, uint256 maxDebtRepay_) external onlyPoolOwner(pool) {
        _poolSettings[pool].maxDebtRepay = maxDebtRepay_;
        emit SetPoolParam(pool, systemParam.MaxDebtRepay, maxDebtRepay_);
    }

    function setInterestRateByPool(address pool, uint256 interestRate_) external onlyPoolOwner(pool) {
        _poolSettings[pool].interestRate = interestRate_;
        _debtSettings[IPool(pool).debtToken()] = interestRate_;
        emit SetPoolParam(pool, systemParam.InterestRate, interestRate_);
    }

    function setLiquidityCoefficientByPool(address pool, uint256 liquidityCoefficient_) external onlyPoolOwner(pool) {
        _poolSettings[pool].liquidityCoefficient = liquidityCoefficient_;
        emit SetPoolParam(pool, systemParam.LiquidityCoefficient, liquidityCoefficient_);
    }

    function setDeviationByPool(address pool, bool deviation_) external onlyPoolOwner(pool) {
        _poolSettings[pool].deviation = deviation_;
        emit SetPoolDeviation(pool, deviation_);
    }

    function setPoolOwner(address pool, address newOwner) external onlyOwner {
        if (_poolSettings[pool].owner != address(0)) {
            _poolSettings[pool].owner = newOwner;
        } else {
            _poolSettings[pool] = PoolSetting(
                newOwner,
                _marginRatio,
                _closingFee,
                _liqFeeBase,
                _liqFeeMax,
                _liqFeeCoefficient,
                _liqLsRequire,
                _rebaseCoefficient,
                _imbalanceThreshold,
                _priceDeviationCoefficient,
                _minHoldingPeriod,
                _debtStart,
                _debtAll,
                _minDebtRepay,
                _maxDebtRepay,
                _interestRate,
                _liquidityCoefficient,
                _deviation
            );
            _debtSettings[IPool(pool).debtToken()] = _interestRate;
        }

        emit SetPoolOwner(pool, newOwner);
    }

    function setOfficial(address official) external onlyOwner {
        _official = official;
    }

    modifier onlyPoolOwner(address pool) {
        require(
            _poolSettings[pool].owner == msg.sender,
            "caller is not the pool owner"
        );
        _;
    }
}
