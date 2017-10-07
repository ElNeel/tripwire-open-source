//
// The developer of the original code and/or files is Tripwire, Inc.
// Portions created by Tripwire, Inc. are copyright (C) 2000-2017 Tripwire,
// Inc. Tripwire is a registered trademark of Tripwire, Inc.  All rights
// reserved.
// 
// This program is free software.  The contents of this file are subject
// to the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or (at your
// option) any later version.  You may redistribute it and/or modify it
// only in compliance with the GNU General Public License.
// 
// This program is distributed in the hope that it will be useful.
// However, this program is distributed AS-IS WITHOUT ANY
// WARRANTY; INCLUDING THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS
// FOR A PARTICULAR PURPOSE.  Please see the GNU General Public License
// for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
// USA.
// 
// Nothing in the GNU General Public License or any other license to use
// the code or files shall permit you to use Tripwire's trademarks,
// service marks, or other intellectual property without Tripwire's
// prior written consent.
// 
// If you have any questions, please contact Tripwire, Inc. at either
// info@tripwire.org or www.tripwire.org.
//
// generatedb_t

#include "engine/stdengine.h"
#include "engine/generatedb.h"
#include "core/fsservices.h"
#include "core/debug.h"
#include "core/errorbucketimpl.h"
#include "fco/fcospecimpl.h"
#include "fco/fcospeclist.h"
#include "fco/twfactory.h"
#include "fco/fconameinfo.h"
#include "fco/genreswitcher.h"
#include "db/hierdatabase.h"
#include "twparser/policyparser.h"
#include "twtest/test.h"

#include <fstream>

void TestGenerateDb()
{
    skip("This test needs to be reworked");

    cDebug d("TestGenerateDb");
    TSTRING db_path     = TwTestPath("gendb.twd");
    TSTRING policy_path = TwTestPath("gendb.pol");

    iFCONameInfo*   pInfo = iTWFactory::GetInstance()->GetNameInfo();
    cErrorTracer    et;
    cHierDatabase   db( pInfo->IsCaseSensitive(), pInfo->GetDelimitingChar() );
    db.Open(db_path.c_str(), 5, true );
    cHierDatabase::iterator iter( &db );
    //
    // make some specs...
    //
    cGenreSpecListVector slv;
    std::ifstream in;
    in.open(policy_path.c_str());
    if(in.fail())
    {
        d.TraceError( "Unable to open policy file!\n" );
        TEST( false );
        return;
    }
    cPolicyParser parser(in);
    parser.Execute(slv, &et);
    
    //
    // ok, time to integrity check!
    //
    cGenreSpecListVector::iterator at;
    for( at = slv.begin(); at != slv.end(); ++at )
    {
        cGenerateDb::Execute( 
                                at->GetSpecList(), 
                                db,
                                cGenreSwitcher::GetInstance()->GetFactoryForGenre( at->GetGenre() )->CreatePropDisplayer(), 
                                &et 
                            );
    }   

}

void RegisterSuite_GenerateDb()
{
    RegisterTest("GenerateDb", "Basic", TestGenerateDb);
}

