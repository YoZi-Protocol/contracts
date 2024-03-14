// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 17061322003236484112486054962859089080535435125912824830118912988588255441486;
    uint256 constant alphay  = 10223766495373370072050636591422531472012761522234276735605463090065553749834;
    uint256 constant betax1  = 5608656050441322795198480614285271845940408385135286443764928558040427121909;
    uint256 constant betax2  = 127418328959658842600771820168291114144520626657787141396838032233535004676;
    uint256 constant betay1  = 19781708964865629184465848078544574167196659019658561902930588482501632744597;
    uint256 constant betay2  = 10732766169545784255037204178368939838911002565709126676860636583200892902616;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 10042014167187424557800331733779602183940666821231946330452759081309442727294;
    uint256 constant deltax2 = 10171245021909906130193569620026496483926664624525743423376927730193460300125;
    uint256 constant deltay1 = 21820949008599079083618102950462989981409559269362034061657903056192517349477;
    uint256 constant deltay2 = 16125930191731389240525803036353738064188309674189703063265490505852876536728;

    
    uint256 constant IC0x = 2016566885919349830255281375775167059355052727281034419490364080770239316692;
    uint256 constant IC0y = 9791833279299439951895473437702800491773405755344664866328538752646561941750;
    
    uint256 constant IC1x = 13744368104889484596768625595646672093932341372191982626787275927482402154448;
    uint256 constant IC1y = 21796000026487180356298873009113464021439052625315792926827453364582529485400;
    
    uint256 constant IC2x = 19102663280305746044028341320198942705877639290179812008007007175466812470686;
    uint256 constant IC2y = 13210049137937982649030315222654025371722077274763678270697047207808697320077;
    
    uint256 constant IC3x = 18568573164042559884426878868087847500128776640361884963936448844075548530043;
    uint256 constant IC3y = 7255506928963829107224618823221109933956364792256460158856223696440986059876;
    
    uint256 constant IC4x = 10466812007129750171420585650291988604294484442347401831776231378304831928480;
    uint256 constant IC4y = 4016674092379606682544771383164770830397994469480913378203026369584100208358;
    
    uint256 constant IC5x = 14651166027193860797384421814181529488052929539440653580450732573482459614109;
    uint256 constant IC5y = 9578904689000100076368087472996054861901883531762489023419816294931187974597;
    
    uint256 constant IC6x = 10113857130017919144963812616856290796570161182160007887600831089199857440567;
    uint256 constant IC6y = 6553732072949623616229331975026408722941154143007727904825217012692669855239;
    
    uint256 constant IC7x = 9882474154788559850202113954884197455008128039932510081071999544657144808234;
    uint256 constant IC7y = 18052065670452441135068810977981140123027292826132927262147780462598461832190;
    
    uint256 constant IC8x = 17863761145426505136924550111832352392077099557084709698618495655099098432647;
    uint256 constant IC8y = 21871047727982196762111397591885083588153038190420615753214502635145409675676;
    
    uint256 constant IC9x = 7686537430141899703229988511824313850094333732836950876912734631096198043088;
    uint256 constant IC9y = 8708648554712684056503160201187893343467235730115944461590441521422325670168;
    
    uint256 constant IC10x = 16454188600065468256999376325873450450470510999915812506087839247014690208681;
    uint256 constant IC10y = 20276677523388925342225279355100971759730403150621440674590675055014692930248;
    
    uint256 constant IC11x = 11748009212559093888897495721406060021088243251577425207598615646449981622124;
    uint256 constant IC11y = 4473848363299703716118178208497119917379854739140715117486688275941431550817;
    
    uint256 constant IC12x = 7065836232673054356422830765030553607140177291092534081573751011903608630071;
    uint256 constant IC12y = 2645423214813892733140951508907691585332423657968849022436289500481463391231;
    
    uint256 constant IC13x = 20224423283321397928904459941820216757780279587446100388407111598999552174593;
    uint256 constant IC13y = 4363598433521600390483906333538950339617125924802891617221826856527600591843;
    
    uint256 constant IC14x = 14266212979522785609016625997556077311949379420794314153130362666281156780413;
    uint256 constant IC14y = 14712964562406930271949882447625716595052380828703956237659396092080904298644;
    
    uint256 constant IC15x = 13695370607628875735862643305842356991794308370237786946531451371780546185409;
    uint256 constant IC15y = 13671576442949938594763625486122155443162983158931311119911448041817437895536;
    
    uint256 constant IC16x = 13057056764860923727193580982059280075360603268649743186216171143885152338727;
    uint256 constant IC16y = 20523273953152034364290564350807044307892513791282643675292443621035708786683;
    
    uint256 constant IC17x = 11289482461432659724316942450500374954244219739947003383285909882197678861975;
    uint256 constant IC17y = 1022055948952217362633429886648132096733493591775169931939987659690732472703;
    
    uint256 constant IC18x = 2146976363039346318836376674312269564438940279400322260794717347016214882917;
    uint256 constant IC18y = 11303654112028863493057014165996466063180451029182524335174767219882503709509;
    
    uint256 constant IC19x = 1133202768017030563310259025973203312853396539556237944750996102553622135124;
    uint256 constant IC19y = 4964950656544519336213434845217014732681236327001539292250555901525563094937;
    
    uint256 constant IC20x = 7379482248659795567762119225804615457533090982187416855539888723792152950592;
    uint256 constant IC20y = 7200622426706479440088104678456494926015935841085547720238427117738075219746;
    
    uint256 constant IC21x = 13305313995973994216928649790547600831594764820986491500034480898478283227948;
    uint256 constant IC21y = 5986640397682188874826097259800162836570178406523802594866486007203309597319;
    
    uint256 constant IC22x = 10018226990127537543949308063539811955851485787830339083221086772905763435272;
    uint256 constant IC22y = 21685917275074192368823964330263616380948974095944389872429147110984876483973;
    
    uint256 constant IC23x = 9249944862707507151415339497735758993881515695531223468472774431773559867935;
    uint256 constant IC23y = 13420861989348770239322841685658549995109110585213612355605706442451453161471;
    
    uint256 constant IC24x = 16129743456112008873439902013822045684505724232958942936089082978502533763976;
    uint256 constant IC24y = 770174043742380500844841224794284689036862225124030186155637319068454607445;
    
    uint256 constant IC25x = 11283348505255804509747522559820793470775623956091194267480312678383643556035;
    uint256 constant IC25y = 12533642900557718555572236063886877185446171996752689765007575626463793673754;
    
    uint256 constant IC26x = 14689957006466746650083205781709223933016892469803487223601677477039769476472;
    uint256 constant IC26y = 154817227027989300928810022626883884219707260412906729076328313127460593239;
    
    uint256 constant IC27x = 17300002011461940925928290456135644644231756883010093934404130833375990649787;
    uint256 constant IC27y = 13406058982400380336438441252853071240287439515187175811139976832666501339299;
    
    uint256 constant IC28x = 18612772536504640534242929375464770146506039175279316263211090053313097464018;
    uint256 constant IC28y = 19192220782980473957119452054996327903932455289445064402753585131301145881209;
    
    uint256 constant IC29x = 17795363758934480824818889878440186733767056102658184471718138985734925446477;
    uint256 constant IC29y = 17068549223957956860724624175434645691367796495077772889924124177945732389191;
    
    uint256 constant IC30x = 12421697784190068199639673892951633068010744559233539025379239216802434904813;
    uint256 constant IC30y = 318041521840174326949243231520101676842431765366439855522835239021502171646;
    
    uint256 constant IC31x = 10185018575359319415820484991841222187652898214001603378006968435225776625446;
    uint256 constant IC31y = 13952686894972527286752144566653262378917519785874504734811241758800038656711;
    
    uint256 constant IC32x = 10826704594020083055517212022340195451818093192186451850467717905665817572226;
    uint256 constant IC32y = 18583363445543595053317654359641999598534135053546718823930015291385340467066;
    
    uint256 constant IC33x = 1235336329705142776515431082556161895848439920186775838854651797783040156751;
    uint256 constant IC33y = 14042745022607611573817905424643375379532748656713905807865525653815487303504;
    
    uint256 constant IC34x = 3686948642033256198355742617249438358179761786663732518550311695262601145599;
    uint256 constant IC34y = 8654742444192959821499428077864278189007053166831007784037046756272959177180;
    
    uint256 constant IC35x = 4964839213026252836106703258595577792837026481552807308411190067426548110439;
    uint256 constant IC35y = 11084833385768827651784381073352051188115875225823789195727661753688935497366;
    
    uint256 constant IC36x = 1218527132501761149334167436585380076664513481247567067911579133514295455644;
    uint256 constant IC36y = 1256053014397061994892670932164023955865915994665698297013111968902004332517;
    
    uint256 constant IC37x = 4589741637210480822525706961690877415110834366701295023767823801124389960467;
    uint256 constant IC37y = 14313168234249484466940052069098803139938688024302774811353818278812077795531;
    
    uint256 constant IC38x = 11920013417535092665918284350890362357948356588381830744484190048979044065590;
    uint256 constant IC38y = 10260439270175016387234651942317289078565385323450861535258217348126675341730;
    
    uint256 constant IC39x = 14801285861828894130856969831887677102290297844783671492896880141280116081659;
    uint256 constant IC39y = 18477808894352792967433491656614982942499470004906679071992810009093213401075;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[39] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
